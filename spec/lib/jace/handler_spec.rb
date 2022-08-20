# frozen_string_literal: true

require 'spec_helper'

describe Jace::Handler do
  let(:context) { instance_double(Context) }

  context 'when handler is initialized with a block' do
    subject(:handler) { described_class.new { method_call } }

    before { allow(context).to receive(:method_call) }

    it 'calls the block' do
      handler.call(context)

      expect(context).to have_received(:method_call).once
    end
  end

  context 'when handler is initialized with a proc' do
    subject(:handler) { described_class.new(proc { method_call }) }

    before { allow(context).to receive(:method_call) }

    it 'calls the block' do
      handler.call(context)

      expect(context).to have_received(:method_call).once
    end
  end

  context 'when handler is initialized with a symbol' do
    subject(:handler) { described_class.new(:method_call) }

    before { allow(context).to receive(:method_call) }

    it 'calls the block' do
      handler.call(context)

      expect(context).to have_received(:method_call).once
    end
  end
end
