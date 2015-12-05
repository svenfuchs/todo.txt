require 'todo/data/list'

describe Todo::Data::List do
  let(:items) { data.map { |data| Todo::Data::Item.new(data) } }
  subject { described_class.new(items) }

  describe 'ids' do
    let(:data) { [{ id: 1 }] }
    it { expect(subject.ids).to eq [1] }
  end

  describe 'max_id' do
    describe 'with a known id' do
      let(:data) { [{ id: 1 }] }
      it { expect(subject.max_id).to eq 1 }
    end

    describe 'with an empty list' do
      let(:data) { [] }
      it { expect(subject.max_id).to eq 0 }
    end
  end

  describe 'next_id' do
    describe 'with a known id' do
      let(:data) { [{ id: 1 }] }
      it { expect(subject.next_id).to eq 2 }
    end

    describe 'with an empty list' do
      let(:data) { [] }
      it { expect(subject.next_id).to eq 1 }
    end
  end

  describe 'toggle' do
    describe 'given a pending line' do
      let(:data) { [ { id: 1, status: :pend }] }
      before { subject.toggle(id: 1) }
      it { expect(subject.send(:items).first.status).to eq :done }
    end

    describe 'given a done line' do
      let(:data) { [ { id: 1, status: :done }] }
      before { subject.toggle(id: 1) }
      it { expect(subject.send(:items).first.status).to eq :pend }
    end

    describe 'given multiple matching items' do
      let(:data) { [{ text: 'foo bar' }, { text: 'foo baz' }] }
      it { expect { subject.toggle(text: 'foo') }.to raise_error(Todo::Error, 'Multiple items found for: text=foo') }
    end

    describe 'no matching item' do
      let(:data) { [{ text: 'buz' }] }
      it { expect { subject.toggle(text: 'foo') }.to raise_error(Todo::Error, 'Could not find item for: text=foo') }
    end
  end
end
