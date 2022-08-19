# frozen_string_literal: true

require 'spec_helper'

describe Jace::Registry do
  subject(:registry) { described_class.new }

  describe '#register' do
    let(:event_name) { :event_name }

    context 'when event is a symbol' do
      it 'adds even to events registry' do
        expect { registry.register(event_name) {} }
          .to change { registry.registry }
          .to({ event_name: { after: [Proc]} })
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .to change { registry.events }
          .by([:event_name])
      end
    end

    context 'when event is a string' do
      let(:event_name) { 'event_name' }

      it 'adds even to events registry' do
        expect { registry.register(event_name) {} }
          .to change { registry.registry }
          .to({ event_name: { after: [Proc]} })
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .to change { registry.events }
          .by([:event_name])
      end
    end

    context 'when the event was already registerd' do
      before { registry.register(event_name) {} }

      it 'adds even a callback to the event registry' do
        expect { registry.register(event_name) {} }
          .to change { registry.registry }
          .to({ event_name: { after: [Proc, Proc]} })
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .not_to(change { registry.events })
      end
    end

    context 'when another event was already registerd' do
      before { registry.register(:other_event_name) {} }

      it 'adds even a callback to the event registry' do
        expect { registry.register(event_name) {} }
          .to change { registry.registry }
          .to({ event_name: { after: [Proc] }, other_event_name: { after: [Proc] } })
      end

      it 'adds event to event list' do
        expect { registry.register(event_name) {} }
          .to change { registry.events }
          .by([:event_name])
      end
    end
  end

  describe '#trigger' do
    let(:event_name) { :event_name }
    let(:context)    { double("context") }

    context 'when an event handler has been registered' do
      before do
        allow(context).to receive(:method_call)
        allow(context).to receive(:other_method)
        registry.register(event_name) { method_call  }
      end

      it "execute the event handler" do
        registry.trigger(event_name, context) {}
        expect(context).to have_received(:method_call)
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
  end
end
