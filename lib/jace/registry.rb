# frozen_string_literal: true

module Jace
  # @api public
  # @author Darthjee
  #
  # Class responsible for registering handlers to events
  class Registry
    # Event & Handlers registry
    #
    # @return [Hash] map of all events and the registered handlers
    def registry
      @registry ||= {}
    end

    # Registered events
    #
    # @return [Array<Symbol>]
    def events
      registry.keys
    end

    # Register a handler to an event
    #
    # @param event [Symbol,String] event name
    # @param instant [Symbol] intant where the handler will be ran (before or
    #   after)
    # @param block [Proc] block to be executed when the event is called
    #
    # @return [Array<Proc>]
    #
    # @example registering an event
    #   registry = described_class.new
    #
    #   registry.register(:the_event) do
    #     do_something_after
    #   end
    #
    #   registry.register(:the_event, :before) do
    #     do_something_before
    #   end
    def register(event, instant = :after, &block)
      registry[event.to_sym] ||= Dispatcher.new
      registry[event.to_sym].send(instant) << block
    end

    # Triggers an event
    # @param event [Symbol,String] event to be triggered
    # @param context [Object] context where the events will be ran
    #
    # @return [Object] the result of the block call
    #
    # @example triggering an event
    #   class SomeContext
    #     def do_something(instant)
    #       puts "doing something #{instant}"
    #     end
    #   end
    #
    #   registry = described_class.new
    #   context = SomeContext.new
    #
    #   registry.register(:the_event) { do_something(:after) }
    #   registry.register(:the_event, :before) { do_something(:before) }
    #
    #   registry.trigger(:the_event, context) do
    #    context.do_something(:middle)
    #   end
    #
    #   # puts 'doing something before',
    #   # puts 'doing something middle',
    #   # puts 'doing something after'
    def trigger(event, context, &block)
      dispatcher_for(event).dispatch(context, &block)
    end

    private

    def dispatcher_for(event)
      registry[event.to_sym] || Dispatcher.new
    end
  end
end
