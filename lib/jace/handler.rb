# frozen_string_literal: true

module Jace
  # @api private
  # @author Darthjee
  #
  # Handler that will be executed once an event has been triggerd
  #
  # Handler will use the given method name or block to execute some code
  # within the given context
  class Handler
    attr_reader :block

    # @overload initialize(method_name)
    #   @param method_name [Symbol] method to be called in context
    # @overload initialize(block)
    #   @param block [Proc] block object to be called within context
    # @overload initialize(&block)
    #   @param block [Proc] block to be called within context
    def initialize(method_name = nil, &block)
      if block
        @block = block if block
      elsif method_name.is_a?(Proc)
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
