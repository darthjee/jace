# frozen_string_literal: true

require 'spec_helper'

describe Jace::Registry do
  subject(:registry) { described_class.new }

  describe '#register' do
    let(:event_name) { :event_name }
    let(:expected_registry) do
      { event_name: Jace::Dispatcher }
    end

    context 'when event is a symbol' do
      it 'adds even to events registry' do
        expect { registry.register(event_name) {} }
          .to change(registry, :registry)
          .to(expected_registry)
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .to change(registry, :events)
          .by([:event_name])
      end
    end

    context 'when event is a string' do
      let(:event_name) { 'event_name' }
      let(:expected_registry) do
        { event_name: Jace::Dispatcher }
      end

      it 'adds even to events registry' do
        expect { registry.register(event_name) {} }
          .to change(registry, :registry)
          .to(expected_registry)
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .to change(registry, :events)
          .by([:event_name])
      end
    end

    context 'when the event was already registerd' do
      before { registry.register(event_name) {} }

      it 'does not repace dispatcher' do
        expect { registry.register(event_name) {} }
          .not_to change(registry, :registry)
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .not_to(change(registry, :events))
      end
    end

    context 'when another event was already registerd' do
      let(:expected_registry) do
        {
          event_name: Jace::Dispatcher,
          other_event_name: Jace::Dispatcher
        }
      end

      before { registry.register(:other_event_name) {} }

      it 'adds even a callback to the event registry' do
        expect { registry.register(event_name) {} }
          .to change(registry, :registry)
          .to(expected_registry)
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .to change(registry, :events)
          .by([:event_name])
      end
    end

    context 'when registering for another instant' do
      let(:expected_registry) do
        {
          event_name: Jace::Dispatcher
        }
      end

      it 'adds even a callback to the event registry' do
        expect { registry.register(event_name, :before) {} }
          .to change(registry, :registry)
          .to(expected_registry)
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .to change(registry, :events)
          .by([:event_name])
      end
    end

    context 'when registering for another instant of an exiosting event' do
      let(:expected_registry) do
        {
          event_name: { before: [Proc], after: [Proc] }
        }
      end

      before { registry.register(event_name, :after) {} }

      it 'does not repace dispatcher' do
        expect { registry.register(event_name, :before) {} }
          .not_to change(registry, :registry)
      end

      it 'does not add event to event list' do
        expect { registry.register(event_name) {} }
          .not_to(change(registry, :events))
      end
    end
  end

  describe '#trigger' do
    let(:event_name) { :event_name }
    let(:context)    { instance_double(Context) }

    context 'when an event handler has been registered' do
      before do
        allow(context).to receive(:method_call)
        allow(context).to receive(:other_method)
        registry.register(event_name) { method_call }
      end

      it 'execute the event handler' do
        registry.trigger(event_name, context) {}
        expect(context).to have_received(:method_call)
      end

      it 'execute the block' do
        registry.trigger(event_name, context) { context.other_method }
        expect(context).to have_received(:other_method)
      end
    end

    context 'when many event handlers have been registered' do
      before do
        allow(context).to receive(:method_call)
        allow(context).to receive(:another_method_call)
        allow(context).to receive(:other_method)

        registry.register(event_name) { method_call }
        registry.register(event_name) { another_method_call }
      end

      it 'execute the event handler' do
        registry.trigger(event_name, context) {}
        expect(context).to have_received(:method_call)
      end

      it 'execute the other event handler' do
        registry.trigger(event_name, context) {}
        expect(context).to have_received(:another_method_call)
      end

      it 'execute the block' do
        registry.trigger(event_name, context) { context.other_method }
        expect(context).to have_received(:other_method).once
      end
    end

    context 'when another event handler has been registered' do
      before do
        allow(context).to receive(:method_call)
        allow(context).to receive(:other_method)
        registry.register(:other_event) { method_call }
      end

      it 'does not execute the event handler' do
        registry.trigger(event_name, context) {}
        expect(context).not_to have_received(:method_call)
      end

      it 'execute the block' do
        registry.trigger(event_name, context) { context.other_method }
        expect(context).to have_received(:other_method)
      end
    end

    context 'when an event handler has not been registered' do
      before do
        allow(context).to receive(:other_method)
      end

      it 'execute the block' do
        registry.trigger(event_name, context) { context.other_method }
        expect(context).to have_received(:other_method)
      end
    end

    context 'when no block is given' do
      before do
        allow(context).to receive(:method_call)

        registry.register(event_name) { method_call }
      end

      it 'execute the event handler' do
        registry.trigger(event_name, context)

        expect(context).to have_received(:method_call)
      end
    end

    describe 'order execution' do
      let(:context) { SomeContext.new }
      let(:expected_texts) do
        [
          'doing something before',
          'doing something middle',
          'doing something after'
        ]
      end

      before do
        registry.register(:the_event) { do_something(:after) }
        registry.register(:the_event, :before) { do_something(:before) }
      end

      it 'runs the event handlers in order' do
        registry.trigger(:the_event, context) do
          context.do_something(:middle)
        end

        expect(context.text).to eq(expected_texts)
      end
    end
  end
end
