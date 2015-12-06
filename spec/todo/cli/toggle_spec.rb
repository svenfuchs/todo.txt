require 'todo/cli/toggle'

describe Todo::Cli::Toggle do
  let(:io)    { Support::Io.new(lines.join("\n")) }
  let(:out)   { Support::Io.new }
  let(:opts)  { { in: io, out: out } }

  subject     { described_class.new(['- foo [1]'], opts) }
  before      { subject.run }

  describe 'with a pending line' do
    let(:lines) { ['- foo [1]', 'x bar done:2015-12-01 [2]'] }
    it { expect(out.readlines).to eq ['x foo done:2015-12-01 [1]', 'x bar done:2015-12-01 [2]'] }
  end

  describe 'with a done line' do
    let(:lines) { ['x foo done:2015-12-01 [1]', 'x bar done:2015-12-01 [2]'] }
    it { expect(out.readlines).to eq ['- foo [1]', 'x bar done:2015-12-01 [2]'] }
  end

  describe 'does not touch other lines' do
    let(:lines) { ['# FOO', '', 'x foo done:2015-12-01 [1]', '  comment'] }
    it { expect(out.readlines).to eq ['# FOO', '', '- foo [1]', '  comment'] }
  end
end
