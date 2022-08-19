# frozen_string_literal: true

require 'spec_helper'

describe Jace::Executer do
  let(:person) { Person.new }

  describe '.call' do
    context 'without before or after' do
      let(:result) do
        described_class.call(context: person) { 10 }
      end

      it 'returns re result of block call' do
        expect(result).to eq(10)
      end

      it 'executes in current context ignoring given context' do
        expect(described_class.call(context: person) { self })
          .to eq(self)
      end
    end

    context 'with before option' do
      context 'with symbol' do
        let(:result) do
          described_class.call(before: :init_age, context: person) do
            person.age
          end
        end

        it 'returns result after running before code' do
          expect(result).to eq(1)
        end

        it 'changes state of context object' do
          expect { result }.to change(person, :age)
            .from(nil).to(1)
        end
      end

      context 'with block' do
        let(:block) { proc { @age = 10 } }

        let(:result) do
          described_class.call(before: block, context: person) { person.age }
        end

        it 'returns result after running before code' do
          expect(result).to eq(10)
        end

        it 'changes state of context object' do
          expect { result }.to change(person, :age)
            .from(nil).to(10)
        end
      end

      context 'with array' do
        let(:block)  { proc { @brothers = @age ? 2 : 10 } }
        let(:before) { [:init_age, block] }

        let(:result) do
          described_class.call(before: before, context: person) do
            person.age + person.brothers
          end
        end

        it 'returns result after running all before code' do
          expect(result).to eq(3)
        end

        it 'changes state of context object by block call' do
          expect { result }.to change(person, :brothers)
            .from(0).to(2)
        end

        it 'changes state of context object by method call' do
          expect { result }.to change(person, :age)
            .from(nil).to(1)
        end
      end
    end

    context 'with after option' do
      context 'with symbol' do
        let(:result) do
          described_class.call(after: :init_age, context: person) { person.age }
        end

        it 'returns result before running after code' do
          expect(result).to be_nil
        end

        it 'changes state of context object' do
          expect { result }.to change(person, :age)
            .from(nil).to(1)
        end
      end

      context 'with block' do
        let(:block) { proc { @age = 10 } }

        let(:result) do
          described_class.call(after: block, context: person) { person.age }
        end

        it 'returns result before running after code' do
          expect(result).to be_nil
        end

        it 'changes state of context object' do
          expect { result }.to change(person, :age)
            .from(nil).to(10)
        end
      end

      context 'with array' do
        let(:block) { proc { @brothers = @age ? 2 : 10 } }
        let(:after) { [:init_age, block] }

        let(:result) do
          described_class.call(after: after, context: person) do
            person.age.to_i + person.brothers
          end
        end

        it 'returns result before running all after code' do
          expect(result).to eq(0)
        end

        it 'changes state of context object by block call' do
          expect { result }.to change(person, :brothers)
            .from(0).to(2)
        end

        it 'changes state of context object by method call' do
          expect { result }.to change(person, :age)
            .from(nil).to(1)
        end
      end
    end

    context 'when no block is provided' do
      let(:result) do
        described_class.call(context: person)
      end

      it do
        expect(result).to be_nil
      end

      context 'when handlers are given' do
        let(:result) do
          described_class.call(before: :init_age, after: :init_height, context: person)
        end

        it do
          expect(result).to be_nil
        end

        it 'calls before handler' do
          expect { result }
            .to change(person, :age)
            .to(1)
        end

        it 'calls after handler' do
          expect { result }
            .to change(person, :height)
            .to(178)
        end
      end
    end
  end
end
