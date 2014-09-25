require 'spec_helper'

RSpec.describe RSpec::Maybes do
  it 'might be defined' do
    maybe { RSpec::Maybes }.will_not raise_error(NameError)
  end

  it 'might be a module' do
    maybe(RSpec::Maybes).will be_an_instance_of(Module)
  end

  it 'really is a module on my machine, though. Yours must be broken.' do
    maybe(RSpec::Maybes).will be_an_instance_of(Module).on_my_machine
  end

  context 'after the syntax is disabled' do
    before { RSpec::Maybes::Syntax.disable_maybe }

    it 'maybe doesnt do anything anymore' do
      maybe(RSpec::Maybes).will_not even_care_anymore
    end

    after { RSpec::Maybes::Syntax.enable_maybe }
  end
end
