require 'todo/data/parser'

describe Todo::Data::Parser do
  let(:data) { described_class.new(line).parse }

  shared_examples_for 'parses the line' do |data|
    it { expect(data[:id]).to eq data[:id] }
    it { expect(data[:text]).to eq data[:text] }
    it { expect(data[:tags]).to eq data[:tags] }
    it { expect(data[:status]).to eq data[:status] }
  end

  describe 'given a pending line' do
    let(:line) { '- foo +bar due:2015-12-01 [1]' }
    include_examples 'parses the line', id: 1, status: :pend, text: 'foo +bar', tags: { due: '2015-12-01' }
  end

  describe 'given a done line' do
    let(:line) { 'x foo +bar done:2015-12-01 [1]' }
    include_examples 'parses the line', id: 1, status: :done, text: 'foo +bar', tags: { done: '2015-12-01' }
  end

  describe 'given a non-todo line' do
    let(:line) { '## foo bar' }
    include_examples 'parses the line', text: '## foo bar', tags: {}
  end
end
