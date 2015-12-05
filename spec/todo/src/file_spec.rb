require 'fileutils'
require 'todo/src/file'

describe Todo::Src::File do
  let(:mode)  {}
  let(:path)  { '/tmp/todo.test.txt' }
  let(:lines) { ['- foo [1]', 'x bar done:2015-12-01 [2]'] }

  subject { described_class.new(path, mode: mode) }

  describe 'read' do
    before { File.open(path, 'w+') { |f| f.puts(lines.join("\n")) } }
    it { expect(subject.read).to eq lines }
  end

  describe 'write' do
    before { File.open(path, 'w+') { |f| f.puts('- buz') } }
    before { subject.write(lines) }
    after  { FileUtils.rm_f(path) }

    describe 'mode a+' do
      let(:mode) { 'a+' }
      it { expect(File.exists?(path)).to be true }
      it { expect(File.read(path)).to eq "- buz\n#{lines.join("\n")}\n" }
    end

    describe 'mode w+' do
      let(:mode) { 'w+' }
      it { expect(File.exists?(path)).to be true }
      it { expect(File.read(path)).to eq "#{lines.join("\n")}\n" }
    end
  end
end
