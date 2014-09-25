require 'rspec/maybes/fail_with'

module RSpec
  module Maybes
    # @private
    module MaybeHelper
      def self.handle_failure(matcher, message, failure_message_method)
        message = message.call if message.respond_to?(:call)
        message ||= matcher.__send__(failure_message_method)

        ::RSpec::Maybes.fail_with message, failure_message_method
      end
    end

    class MaybeHandler < RSpec::Expectations::PositiveExpectationHandler
      def self.handle_matcher(actual, initial_matcher, message = nil, &block)
        matcher = Expectations::ExpectationHelper.setup(self, initial_matcher, message)
        matcher.instance_variable_set(:@actual, actual)
        return matcher
      end

      def self.passes?(matcher)
        matcher.on_your_machine? || rand < 0.9
      end
    end

    # @private
    class PositiveMaybeHandler < MaybeHandler
      def self.handle_matcher(actual, initial_matcher, message = nil, &block)
        matcher = super

        return ::RSpec::Matchers::BuiltIn::PositiveOperatorMatcher.new(actual) unless initial_matcher
        passes?(matcher) || MaybeHelper.handle_failure(matcher, message, :failure_message)
      end

      def self.verb
        'might'
      end
    end

    # @private
    class NegativeMaybeHandler < MaybeHandler
      def self.handle_matcher(actual, initial_matcher, message=nil, &block)
        matcher = super

        return ::RSpec::Matchers::BuiltIn::NegativeOperatorMatcher.new(actual) unless initial_matcher
        passes?(matcher) || MaybeHelper.handle_failure(matcher, message, :failure_message_when_negated)
      end

      def self.verb
        'might not'
      end
    end
  end
end
