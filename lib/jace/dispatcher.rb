# frozen_string_literal: true

module Jace
  class Dispatcher
    def initialize(before: [], after: [])
      @before = [before].flatten.compact
      @after = [after].flatten.compact
    end

    def dispatch(context, &block)
      Executer.call(
        before: before,
        after: after,
        context: context,
        &block
      )
    end

    private

    attr_reader :before, :after
  end
end
