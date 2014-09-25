# encoding: utf-8
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rspec/maybes/version'

Gem::Specification.new do |spec|
  spec.name          = 'spec-me-maybe'
  spec.version       = RSpec::Maybes::VERSION
  spec.authors       = ['David Celis']
  spec.email         = ['me@davidcel.is']
  spec.summary       = 'Adds the `maybe` syntax to RSpec.'
  spec.description   = <<-DESCRIPTION.gsub(/^\s{4}/, '')
    Adds the `maybe` syntax to RSpec:

        describe Thing do
          it 'is maybe equal to another thing' do
            maybe(Thing.new).will eq(another_thing) # Passes sometimes. Maybe.
          end
        end
  DESCRIPTION

  spec.homepage      = 'https://github.com/davidcelis/spec-me-maybe'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.test_files    = Dir['spec/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_dependency 'rspec-expectations', '~> 3.1'

  spec.add_development_dependency 'rspec', '~> 3.1'
end
