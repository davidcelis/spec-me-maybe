require 'rspec/maybes/maybe_target'

module RSpec
  module Maybes
    # @api private
    # Provides methods for enabling and disabling the maybe syntax
    module Syntax
      MONKEYMATCHERS = [
        RSpec::Matchers::BuiltIn::BaseMatcher,
        RSpec::Matchers::BuiltIn::RaiseError,
        RSpec::Matchers::BuiltIn::ThrowSymbol
      ]

      module_function

      # @api private
      # Enables the `maybe` syntax.
      def enable_maybe(syntax_host = ::RSpec::Matchers)
        return if maybe_enabled?(syntax_host)

        syntax_host.module_exec do
          def maybe(value = ::RSpec::Maybes::MaybeTarget::UndefinedValue, &block)
            ::RSpec::Maybes::MaybeTarget.for(value, block)
          end
        end

        MONKEYMATCHERS.each do |matcher|
          matcher.class_eval do
            alias old_matches? matches?

            def matches?(actual)
              @actual = actual
              @your_machine || old_matches?(actual)
            end

            def on_my_machine
              @your_machine = true
              return self
            end

            def on_your_machine?() defined?(@your_machine) && @your_machine end
          end
        end
      end

      # @api private
      # Disables the `maybe` syntax.
      def disable_maybe(syntax_host = ::RSpec::Matchers)
        return unless maybe_enabled?(syntax_host)

        syntax_host.module_exec do
          undef maybe
        end

        MONKEYMATCHERS.each do |matcher|
          matcher.class_eval do
            undef matches?
            alias matches? old_matches?
            undef old_matches?

            undef on_my_machine
            undef on_your_machine?
          end
        end
      end

      # @api private
      # Indicates whether or not the `maybe` syntax is enabled.
      def maybe_enabled?(syntax_host = ::RSpec::Matchers)
        syntax_host.method_defined?(:maybe)
      end
    end
  end
end
