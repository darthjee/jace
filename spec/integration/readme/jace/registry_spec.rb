# frozen_string_literal: true

require 'spec_helper'

describe Jace::Registry do
  describe 'yard' do
    subject(:registry) { described_class.new }

    let(:context) { SomeContext.new }
    let(:expected_texts) do
      [
        'doing something before',
        'doing something middle',
        'doing something after'
      ]
    end

    it 'runs the event handlers' do
      registry.register(:the_event) { do_something(:after) }
      registry.register(:the_event, :before) { do_something(:before) }

      registry.trigger(:the_event, context) do
        context.do_something(:middle)
      end

      expect(context.text)
        .to eq(expected_texts)
    end
  end
end
