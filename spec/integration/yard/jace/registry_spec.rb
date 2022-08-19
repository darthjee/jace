# frozen_string_literal: true

require 'spec_helper'

describe Jace::Registry do
  subject(:registry) { described_class.new }

  describe '#register' do
    it 'register a new handler for an event' do
      registry.register(:the_event) do
        do_something_after
      end
    end

    it 'register a new handler for before an event' do
      registry.register(:the_event, :before) do
        do_something_before
      end
    end
  end
end
