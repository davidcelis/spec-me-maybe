require 'rspec/maybes/syntax'

module RSpec
  module Core
    class Configuration
      def conditionally_disable_expectations_monkey_patching
        return unless disable_monkey_patching && rspec_expectations_loaded?

        RSpec::Expectations.configuration.syntax = :maybe
      end
    end
  end

  module Expectations
    class Configuration
      alias :original_syntax= :syntax=
      alias :original_syntax  :syntax

      # Configures the supported syntax.
      # @param [Array<Symbol>, Symbol] values the syntaxes to enable
      # @example
      #   RSpec.configure do |rspec|
      #     rspec.expect_with :rspec do |c|
      #       c.syntax = :maybe
      #       # or
      #       c.syntax = :expect
      #       # or
      #       c.syntax = [:maybe, :expect]
      #     end
      #   end
      def syntax=(values)
        original_syntax = values

        if Array(values).include?(:maybe)
          Maybes::Syntax.enable_maybe
        else
          Maybes::Syntax.disable_maybe
        end
      end

      # The list of configured syntaxes.
      # @return [Array<Symbol>] the list of configured syntaxes.
      # @example
      #   unless RSpec::Matchers.configuration.syntax.include?(:maybe)
      #     raise "this RSpec extension gem requires the spec-me-maybe `:maybe` syntax"
      #   end
      def syntax
        syntaxes = original_syntaxes
        syntaxes << :maybe if Maybes::Syntax.maybe_enabled?
        syntaxes
      end
    end
  end
end
