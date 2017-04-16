# spec-me-maybe [![Build Status][travis-badge]][travis]

Are your tests order-dependent? Tired of all those randomly failing specs? Can't be bothered to use [Timecop][timecop]? Just give up and surrender. But at least use a proper syntax.

Introducing the `maybe` syntax for RSpec.

[timecop]: https://github.com/travisjeffery/timecop
[travis]: https://travis-ci.org/davidcelis/spec-me-maybe
[travis-badge]: http://img.shields.io/badge/build-probably-yellow.svg

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

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # Enable the `maybe` syntax from spec-me-maybe, e.g.:
    #   maybe(actual).will eq(expected)
    expectations.syntax = :maybe
  end
end
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

Whereas `expect` would set up an `RSpec::Expectations::ExpectationTarget`, `maybe` will instead set up an `RSpec::Maybe::MaybeTarget`. Like expectations, maybes may or may not fail. In the case of maybes, however, they will fail randomly regardless of your code. But hey, maybe your Expectations were like that too.

If your colleagues' complaints of broken specs are totally bullshit because you're _super_ sure they work on your machine, we've got you covered. Here's the above example again, but this time it'll totally always pass:

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

## How it works

In Ruby, what actually happens when you call a method is that you send a
message to the receiver.

```ruby
class MyClass
  def example_method(my_arg)
    my_arg * 3
  end
end

obj = MyClass.new
obj = example_method(3) #=> 9

obj.send(:my_method, 3) #=> 9
```

Additionally, you can set the parameters of these methods with a block
using the #call method. Together, these two concepts form the core of
how spec-me-maybe works.

```ruby
number = Proc.new {|str| "maybe"}

number.call("me") #=> "maybe"

```

[More in-depth explanation here.](https://www.youtube.com/watch?v=fWNaR-rxAic)




## Contributing

1. [Fork it](https://github.com/davidcelis/spec-me-maybe/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
