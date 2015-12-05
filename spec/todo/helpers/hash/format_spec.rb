require 'todo/helpers/hash/format'

describe Todo::Helpers::Hash::Format do
  let(:hash) { { foo: 'foo', bar: 'bar' } }
  subject { described_class }

  it { expect(subject.to_pairs(hash)).to eq ['foo=foo', 'bar=bar'] }
  it { expect(subject.to_pairs(hash, ':')).to eq ['foo:foo', 'bar:bar'] }
end
