require 'todo/cli/list'

describe Todo::Cli::List do
  let(:io)    { Support::Io.new(lines.join("\n")) }
  let(:out)   { Support::Io.new }

  subject     { described_class.new([], opts.merge(in: io, out: out)) }
  before      { subject.run }

  describe 'filtering' do
    let(:lines) { ['- foo +abc [1]', 'x bar done:2015-10-01 [2]', 'x baz done:2015-11-01 [2]', 'x baz +abc done:2015-12-01 [2]'] }

    describe 'unfiltered' do
      let(:opts)  { {} }
      it { expect(out.readlines).to eq ['- foo +abc', 'x 2015-10-01 bar', 'x 2015-11-01 baz', 'x 2015-12-01 baz +abc'] }
    end

    describe 'by done date' do
      let(:opts)  { { after: '2015-11-31' } }
      it { expect(out.readlines).to eq ['x 2015-12-01 baz +abc'] }
    end

    describe 'by status :pending' do
      let(:opts)  { { status: :pending } }
      it { expect(out.readlines).to eq ['- foo +abc'] }
    end

    describe 'by status :done' do
      let(:opts)  { { status: :done } }
      it { expect(out.readlines).to eq ['x 2015-10-01 bar', 'x 2015-11-01 baz', 'x 2015-12-01 baz +abc'] }
    end

    describe 'by status :done and :after' do
      let(:opts)  { { status: :done, after: '2015-11-31' } }
      it { expect(out.readlines).to eq ['x 2015-12-01 baz +abc'] }
    end

    describe 'by status :done and :after' do
      let(:opts)  { { status: :done, after: '2015-11-01', before: '2015-11-07' } }
      it { expect(out.readlines).to eq ['x 2015-11-01 baz'] }
    end

    describe 'by project' do
      let(:opts)  { { projects: ['abc'] } }
      it { expect(out.readlines).to eq ['- foo +abc', 'x 2015-12-01 baz +abc'] }
    end

    describe 'by text' do
      let(:opts)  { { text: 'baz' } }
      it { expect(out.readlines).to eq ['x 2015-11-01 baz', 'x 2015-12-01 baz +abc'] }
    end
  end

  describe 'format' do
    let(:lines) { ['- foo +abc [1]', 'x bar done:2015-12-01 [2]'] }

    describe 'short' do
      let(:opts)  { { format: 'short' } }
      it { expect(out.readlines).to eq ['- foo +abc', 'x 2015-12-01 bar'] }
    end

    describe 'full' do
      let(:opts)  { { format: 'full' } }
      it { expect(out.readlines).to eq ['- foo +abc [1]', 'x bar done:2015-12-01 [2]'] }
    end

    describe 'custom: text,tags' do
      let(:opts)  { { format: 'text,tags' } }
      it { expect(out.readlines).to eq ['foo +abc', 'bar done:2015-12-01'] }
    end

    describe 'custom: id:text' do
      let(:opts)  { { format: 'id:text' } }
      it { expect(out.readlines).to eq ['[1] foo +abc', '[2] bar'] }
    end
  end
end
