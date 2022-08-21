# frozen_string_literal: true

module Jace
  # @api private
  # @author Darthjee
  class Handler
    attr_reader :block

    def initialize(method_name = nil, &block)
      return @block = block if block

      if method_name.is_a?(Proc)
        @block = method_name
      else
        @block = proc { send(method_name) }
      end
    end

    def call(context)
      context.instance_eval(&block)
    end

    def to_proc
      handler = self
      proc { |context| handler.call(context) }
    end
  end
end
