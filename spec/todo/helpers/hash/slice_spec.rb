require 'todo/helpers/hash/slice'

describe Todo::Helpers::Hash::Slice do
  let(:hash) { { foo: 'foo', bar: 'bar' } }
  subject { described_class }

  it { expect(subject.slice(hash, :foo, :baz)).to eq(foo: 'foo') }
end
