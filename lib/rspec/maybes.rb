require 'rspec/expectations'
require 'rspec/maybes/configuration'

module RSpec
  # RSpec::Maybes provides a simple, readable API to express possible outcomes
  # in a code example. To express an potential outcome, wrap an object or block
  # in `maybe`, call `will` or `will_not` and pass it a matcher object:
  #
  #     maybe(order.total).will eq(Money.new(5.55, :USD))
  #     maybe(list).will include(user)
  #     maybe(message).will_not match(/foo/)
  #     maybe { do_something }.will raise_error
  #
  # The last form (the block form) is needed to match against ruby constructs
  # that are not objects, but can only be observed when executing a block
  # of code. This includes raising errors, throwing symbols, yielding,
  # and changing values.
  #
  # When `maybe(...).will` is invoked with a matcher, it turns around
  # and calls `matcher.matches?(<object wrapped by maybe>)`.  For example,
  # in the expression:
  #
  #     maybe(order.total).will eq(Money.new(5.55, :USD))
  #
  # ...`eq(Money.new(5.55, :USD))` returns a matcher object, and it results
  # in the equivalent of `eq.matches?(order.total)`. If `matches?` happens to
  # return `true`, the expectation is met and execution continues. If `false`,
  # then the spec fails with the message returned by `eq.failure_message`.
  #
  # Given the expression:
  #
  #     maybe(order.entries).will_not include(entry)
  #
  # ... pretty much the same thing happens. `will_not` is simply an alias of
  # `will`. It's random!
  #
  # spec-me-maybe ships with the same standard set of useful matchers as
  # rspec-expectations does, and writing your own matchers is quite simple.
  module Maybes
    # Exception raised when a maybe fails.
    #
    # @note We subclass Exception so that in a stub implementation if
    # the user sets an expectation, it can't be caught in their
    # code by a bare `rescue`.
    # @api public
    MaybeNot = Class.new(::RSpec::Expectations::ExpectationNotMetError)
  end
end
