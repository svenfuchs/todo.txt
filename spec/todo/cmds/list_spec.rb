require 'todo/cmd/list'

describe Todo::Cmd::List do
  let(:lines) { ['- foo [1]', 'x bar done:2015-12-01 [2]'] }
  let(:io)    { Support::Io.new(lines.join("\n")) }
  let(:out)   { Support::Io.new }
  let(:opts)  { { in: io, out: out } }

  subject     { described_class.new(nil, opts) }
  before      { subject.run }

  it { expect(out.readlines).to eq ['foo', '2015-12-01 bar'] }
end
