# spec-me-maybe [![Build Status](http://img.shields.io/badge/build-probably-yellow.svg)][travis]

Are your tests order-dependent? Tired of all those randomly failing specs? Can't be bothered to use [Timecop][timecop]? Just give up and surrender. But at least use a proper syntax.

Introducing the `maybe` syntax for RSpec.

[timecop]: https://github.com/travisjeffery/timecop
[travis]: https://travis-ci.org/davidcelis/spec-me-maybe
[travis-badge]: https://travis-ci.org/davidcelis/spec-me-maybe.svg?branch=master

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spec-me-maybe'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install spec-me-maybe
```

Then, in your `spec_helper.rb` file:

```ruby
require 'rspec/maybes'
```

## Usage

The "maybe" syntax looks and feels almost exactly like the "expect" syntax:

```ruby
describe User do
  describe '#initialize' do
    let(:user) { User.new(name: 'David Celis') }

    it 'should set up a name' do
      maybe(user.name).will eq 'David Celis'
    end

    it 'probably should not raise any sort of error' do
      maybe { user }.will_not raise_error
    end
  end
end
```

Whereas `expect` would set up an `RSpec::Expectation`, `maybe` will instead set up an `RSpec::Maybe`. Also like Expectations, Maybes might or might not pass. In this case, however, it will pass randomly. But hey, maybe your Expectations were like that too.

If your colleagues' complaints of broken specs are totally bullshit because you're super sure they work on your machine, we've got you covered. Here's the same above example, but it'll totally always pass:

```ruby
describe User do
  describe '#initialize' do
    let(:user) { User.new(name: 'David Celis') }

    it 'should set up a name' do
      maybe(user.name).will eq('David Celis').on_my_machine
    end

    it 'probably should not raise any sort of error' do
      maybe { user }.will_not raise_error.on_my_machine
    end
  end
end
```

## Contributing

1. [Fork it](https://github.com/davidcelis/spec-me-maybe/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
