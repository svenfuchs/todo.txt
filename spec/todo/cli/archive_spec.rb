require 'todo/cli/archive'
require 'fileutils'

describe Todo::Cli::Archive do
  let(:lines) { ['- foo [1]', 'x bar done:2015-11-01 [2]', 'x baz done:2015-12-01 [3]'] }
  let(:io)    { Support::Io.new(lines.join("\n")) }
  let(:out)   { Support::Io.new }
  let(:opts)  { { archive: '/tmp/todo.archive.txt', in: io, out: out } }

  subject     { described_class.new(nil, opts) }
  before      { subject.run }
  after       { FileUtils.rm_f(opts[:archive]) }

  it { expect(out.readlines).to eq ['- foo [1]', 'x baz done:2015-12-01 [3]'] }
  it { expect(File.read(opts[:archive]).strip).to eq 'x bar done:2015-11-01 [2]' }
end
