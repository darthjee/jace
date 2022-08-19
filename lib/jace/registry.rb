# frozen_string_literal: true

module Jace
  # @api public
  # @author Darthjee
  #
  # Class responsible for registering handlers to events
  class Registry
    def registry
      @registry ||= {}
    end

    def events
      registry.keys
    end

    def register(event, instant = :after, &block)
      registry[event.to_sym] ||= {}
      registry[event.to_sym][instant] ||= []
      registry[event.to_sym][instant] << block
    end

    def trigger(event, context, &block)
      Dispatcher.new(registry[event.to_sym]).dispatch(context, &block)
    end
  end
end
