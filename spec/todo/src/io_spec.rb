require 'todo/src/io'

describe Todo::Src::Io do
  let!(:io)   { Support::Io.new }
  let(:lines) { ['- foo [1]', 'x bar done:2015-12-01 [2]'] }

  subject { described_class.new(in: io, out: io) }

  describe 'read' do
    before { io.puts(lines.join("\n")) }
    it { expect(subject.read).to eq lines }
  end

  describe 'write' do
    before { subject.write(lines) }
    it { expect(io.string).to eq "#{lines.join("\n")}\n" }
  end
end
