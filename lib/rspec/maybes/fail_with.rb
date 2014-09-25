module RSpec
  module Maybes
    class << self
      # Raises an RSpec::Maybes::MaybeNot with message.
      # @param [String] message
      #
      # Adds a diff to the failure message when `expected` and `actual` are
      # both present.
      def fail_with(message, failure_message_method)
        unless message
          raise ArgumentError, "Failure message is nil. Does your matcher define the " \
                               "appropriate failure_message[_when_negated] method to return a string?"
        end

        message = "#{message} Maybe next time, though?"

        raise RSpec::Maybes::MaybeNot, message
      end
    end
  end
end
