require 'todo/data/item'

describe Todo::Data::Item do
  let(:data) { { id: 1, status: :done, text: 'foo +bar', tags: { done: '2015-12-01' } } }
  subject { described_class.new(data) }

  it { expect(subject.id).to eq data[:id] }
  it { expect(subject.status).to eq data[:status] }
  it { expect(subject.text).to eq data[:text] }
  it { expect(subject.tags).to eq data[:tags] }

  describe 'done?' do
    describe 'when status is :done' do
      let(:data) { { status: :done } }
      it { should be_done }
    end

    describe 'when status is not :done' do
      let(:data) { { status: :pend } }
      it { should_not be_done }
    end
  end

  describe 'done_date' do
    describe 'given a :done tag' do
      let(:data) { { tags: { done: '2015-12-01' } } }
      it { expect(subject.done_date).to eq '2015-12-01' }
    end

    describe 'given no :done tag' do
      let(:data) { { tags: {} } }
      it { expect(subject.done_date).to be_nil }
    end
  end

  describe 'due_date' do
    describe 'given a :due tag' do
      let(:data) { { tags: { due: '2015-12-01' } } }
      it { expect(subject.due_date).to eq '2015-12-01' }
    end

    describe 'given no :due tag' do
      let(:data) { { tags: {} } }
      it { expect(subject.due_date).to be_nil }
    end
  end

  describe 'projects' do
    let(:data) { { text: '+foo text +bar text +baz' } }
    it { expect(subject.projects).to eq %w(foo bar baz) }
  end

  describe 'toggle' do
    before { subject.toggle }

    describe 'given a pending item' do
      let(:data) { { status: :pend } }
      it { expect(subject.status).to eq :done }
      it { expect(subject.done_date).to eq '2015-12-01' }
    end

    describe 'given a done item' do
      let(:data) { { status: :done, tags: { done: '2015-12-01' } } }
      it { expect(subject.status).to eq :pend }
      it { expect(subject.done_date).to be_nil }
    end
  end

  describe 'matches?' do
    describe 'given an id' do
      describe 'matches' do
        let(:other) { { id: 1, text: 'does not match' } }
        it { expect(subject.matches?(other)).to be true }
      end

      describe 'does not match' do
        let(:other) { { id: 2, text: 'does not match' } }
        it { expect(subject.matches?(other)).to be false }
      end
    end

    describe 'given a text' do
      describe 'matches' do
        let(:other) { { text: 'foo +bar' } }
        it { expect(subject.matches?(other)).to be true }
      end

      describe 'does not match' do
        let(:other) { { text: 'does not match' } }
        it { expect(subject.matches?(other)).to be false }
      end
    end
  end
end
