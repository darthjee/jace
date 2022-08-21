# frozen_string_literal: true

module Jace
  # @api private
  # @author Dartjee
  #
  # Class responsible for executing a given block and triggering event
  #
  # The event trigger has phase before and after so all methods
  # are called before block execution and after, before returning the result
  class Executer
    # Calls the execution
    #
    # @param before [Symbol,Proc,Array] all the methods / proc
    #   to be executed before block call
    # @param after [Symbol,Proc,Array] all the methods / proc
    #   to be executed after block call
    # @param context [Object] Object where the procs / methods
    #   will be called on
    # @block [Proc] bloc to be performed between befores and afters
    #
    # @return [Object] result of block call
    def self.call(before: [], after: [], context:, &block)
      new(before, after, context, &block).call
    end

    # calls the execution
    #
    # @see .call
    #
    # @return (see .call)
    def call
      execute_actions(before)
      result = block.call if block
      execute_actions(after)

      result
    end

    private

    # @private
    #
    # @param (see .call)
    def initialize(before, after, context, &block)
      @before = [before].flatten.compact
      @after = [after].flatten.compact
      @context = context
      @block = block
    end

    attr_reader :before, :after, :context, :block

    # @method before
    # @private
    # @api private
    #
    # Contains a list of event handlers to be called before
    #
    # @return (see Jace::Dispatcher#before)

    # @method after
    # @private
    # @api private
    #
    # Contains a list of event handlers to be called after
    #
    # @return (see Jace::Dispatcher#after)

    # @method context
    # @private
    # @api private
    #
    # context where the events handlers will be executed
    #
    # all the method calls inside the event handler will be evaluated
    # from within the context
    #
    # @return [Object]

    # @method block
    # @private
    # @api private
    #
    # block to be executed representing the event
    #
    # the block is executed after the +before+ handlers
    # and before the +after+ handlers
    #
    # @return [Proc]

    # @private
    #
    # Perform actions from list
    #
    # @list [Array<Symbol,Proc>] methods and procs to
    #   be executed
    #
    # Execute each proc and call method in the list
    # within the given context
    #
    # @return [Array<Proc>]
    def execute_actions(list)
      actions(list).each do |action|
        context.instance_eval(&action)
      end
    end

    # @private
    #
    # Transforms the input objects into hadlers
    #
    # @param list [Array<Symbol,Proc>] method or proc to be transformed
    #
    # @return [Array<Handler>]
    def actions(list)
      list.map do |entry|
        Handler.new(entry)
      end
    end
  end
end
