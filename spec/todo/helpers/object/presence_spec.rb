require 'todo/helpers/object/presence'

describe Todo::Helpers::Object::Presence do
  subject { described_class }

  describe 'present?' do
    it { expect(subject.present?(nil)).to be false }
    it { expect(subject.present?(true)).to be true }
    it { expect(subject.present?(false)).to be false }

    it { expect(subject.present?(1)).to be true }
    it { expect(subject.present?(1.1)).to be true }

    it { expect(subject.present?([])).to be false }
    it { expect(subject.present?([1])).to be true }

    it { expect(subject.present?({})).to be false }
    it { expect(subject.present?(foo: :bar)).to be true }

    it { expect(subject.present?('')).to be false }
    it { expect(subject.present?('foo')).to be true }
  end

  describe 'blank?' do
    it { expect(subject.blank?(nil)).to be true }
    it { expect(subject.blank?(true)).to be false }
    it { expect(subject.blank?(false)).to be true }

    it { expect(subject.blank?(1)).to be false }
    it { expect(subject.blank?(1.1)).to be false }

    it { expect(subject.blank?([])).to be true }
    it { expect(subject.blank?([1])).to be false }

    it { expect(subject.blank?({})).to be true }
    it { expect(subject.blank?(foo: :bar)).to be false }

    it { expect(subject.blank?('')).to be true }
    it { expect(subject.blank?('foo')).to be false }
  end
end

