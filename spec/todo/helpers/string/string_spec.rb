require 'todo/helpers/string/camelize'

describe Todo::Helpers::String::Camelize do
  subject { described_class }

  it { expect(subject.camelize('foo_bar')).to eq 'FooBar' }
end
