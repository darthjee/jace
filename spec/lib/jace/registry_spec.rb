# frozen_string_literal: true

require 'spec_helper'

describe Jace::Registry do
  subject(:registry) { described_class.new }

  describe '#register' do
    context 'when event is a symbol' do
      let(:event_name) { :event_name }

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
  end

  describe '#trigger' do
  end
end
