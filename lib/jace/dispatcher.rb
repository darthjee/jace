# frozen_string_literal: true

module Jace
  # @api private
  # @author Darthjee
  #
  # Class responsible for dispatching the call of events
  class Dispatcher
    # @param before [Symbol,Proc,Array] all the methods / proc
    #   to be executed before block call
    # @param after [Symbol,Proc,Array] all the methods / proc
    #   to be executed after block call
    def initialize(before: [], after: [])
      @before = [before].flatten.compact
      @after = [after].flatten.compact
    end

    # Dispatch the event call on a context
    #
    # @param context [Object] Object where the procs / methods
    #   will be called on
    # @block [Proc] bloc to be performed between befores and afters
    #
    # @return [Object] result of block call
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

    # @method before
    # @private
    # @api private
    #
    # Contains a list of event handlers to be called before
    #
    # @return [Array<Object>] list of handlers

    # @method after
    # @private
    # @api private
    #
    # Contains a list of event handlers to be called after
    #
    # @return [Array<Object>] list of handlers
  end
end
