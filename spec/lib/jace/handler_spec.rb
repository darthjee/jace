# frozen_string_literal: true

require 'spec_helper'

describe Jace::Handler do
  let(:context) { instance_double(Context) }

  describe '#call' do
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

  describe '#to_proc' do
    context 'when handler is initialized with a block' do
      subject(:handler) { described_class.new { method_call } }

      it do
        expect(handler.to_proc).to be_a(Proc)
      end

      context 'when the proc is called' do
        before { allow(context).to receive(:method_call) }

        it 'calls the block' do
          context.instance_eval(&(handler.to_proc))

          expect(context).to have_received(:method_call).once
        end
      end
    end

    context 'when handler is initialized with a proc' do
      subject(:handler) { described_class.new(proc { method_call }) }

      it do
        expect(handler.to_proc).to be_a(Proc)
      end

      context 'when the proc is called' do
        before { allow(context).to receive(:method_call) }

        it 'calls the block' do
          context.instance_eval(&(handler.to_proc))

          expect(context).to have_received(:method_call).once
        end
      end
    end

    context 'when handler is initialized with a symbol' do
      subject(:handler) { described_class.new(:method_call) }

      it do
        expect(handler.to_proc).to be_a(Proc)
      end

      context 'when the proc is called' do
        before { allow(context).to receive(:method_call) }

        it 'calls the block' do
          context.instance_eval(&(handler.to_proc))

          expect(context).to have_received(:method_call).once
        end
      end
    end
  end
end
