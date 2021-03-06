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
      result = block.call
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
    # Transforms the input object into a Proc
    #
    # @param list [Symbol,Proc] method or proc to be transformed
    #
    # @return [Proc]
    def actions(list)
      list.map do |entry|
        if entry.is_a?(Proc)
          proc(&entry)
        else
          proc { send(entry) }
        end
      end
    end
  end
end
