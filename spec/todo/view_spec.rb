require 'todo/view'

describe Todo::View do
  let(:lines) { ['- foo [1]', 'x bar done:2015-12-01 [2]'] }
  let(:items) { Todo::Data::List.parse(lines).items }
  subject     { described_class.new(items, format: format) }

  describe 'default columns' do
    let(:format) {}
    it { expect(subject.render).to eq(lines) }
  end

  describe 'selected columns' do
    let(:format) { 'text:tags' }
    it { expect(subject.render).to eq(['foo', 'bar done:2015-12-01']) }
  end

  describe 'format name' do
    let(:format) { :short }
    it { expect(subject.render).to eq(['foo', '2015-12-01 bar']) }
  end
end
