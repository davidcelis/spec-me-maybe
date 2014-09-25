require 'rspec/maybes/handlers'

module RSpec
  module Maybes
    # Wraps the target of a maybe.
    #
    # @example
    #   maybe(something)       # => MaybeTarget wrapping something
    #   maybe { do_something } # => MaybeTarget wrapping the block
    #
    #   # used with `will`
    #   maybe(actual).will eq(3)
    #
    #   # with `will_not`
    #   maybe(actual).will_not eq(3)
    #
    # @note `MaybeTarget` is not intended to be instantiated
    #   directly by users. Use `maybe` instead.
    class MaybeTarget
      # @private
      # Used as a sentinel value to be able to tell when the user
      # did not pass an argument. We can't use `nil` for that because
      # `nil` is a valid value to pass.
      UndefinedValue = Module.new

      # @api private
      def initialize(value)
        @target = value
      end

      # @private
      def self.for(value, block)
        if UndefinedValue.equal?(value)
          unless block
            raise ArgumentError, "You must pass either an argument or a block to `maybe`."
          end
          BlockMaybeTarget.new(block)
        elsif block
          raise ArgumentError, "You cannot pass both an argument and a block to `maybe`."
        else
          new(value)
        end
      end

      # Runs the given maybe, passing randomly.
      # @example
      #   maybe(value).will eq(5)
      #   maybe { perform }.will_not raise_error
      # @param [Matcher]
      #   matcher
      # @param [String or Proc] message optional message to display when the expectation fails
      # @return [Boolean] true if the maybe succeeds (else raises)
      # @see RSpec::Matchers
      def will(matcher = nil, message = nil, &block)
        prevent_operator_matchers(:will) unless matcher
        RSpec::Maybes::PositiveMaybeHandler.handle_matcher(@target, matcher, message, &block)
      end

      # Runs the given maybe, failing randomly.
      # @example
      #   maybe(value).will_not eq(5)
      # @param [Matcher]
      #   matcher
      # @param [String or Proc] message optional message to display when the maybe fails
      # @return [Boolean] false if the negative maybe succeeds (else raises)
      # @see RSpec::Matchers
      def will_not(matcher = nil, message = nil, &block)
        prevent_operator_matchers(:will_not) unless matcher
        RSpec::Maybes::NegativeMaybeHandler.handle_matcher(@target, matcher, message, &block)
      end

      private

      def prevent_operator_matchers(verb)
        raise ArgumentError, "The maybe syntax does not support operator matchers, " \
                             "so you must pass a matcher to `##{verb}`."
      end
    end

    # @private
    # Validates the provided matcher to ensure it supports block
    # maybes, in order to avoid user confusion when they
    # use a block thinking the maybe will be on the return
    # value of the block rather than the block itself.
    class BlockMaybeTarget < MaybeTarget
      def will(matcher, message = nil, &block)
        enforce_block_maybe(matcher)
        super
      end

      def will_not(matcher, message = nil, &block)
        enforce_block_maybe(matcher)
        super
      end

      private

      def enforce_block_maybe(matcher)
        return if supports_block_maybes?(matcher)

        raise MaybeNot, "You must pass an argument rather than " \
          "a block to use the provided matcher (#{description_of matcher}), or " \
          "the matcher must implement `supports_block_expectations?`."
      end

      def supports_block_maybes?(matcher)
        matcher.supports_block_expectations?
      rescue NoMethodError
        false
      end

      def description_of(matcher)
        matcher.description
      rescue NoMethodError
        matcher.inspect
      end
    end
  end
end
