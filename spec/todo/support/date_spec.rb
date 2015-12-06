require 'todo/support/date'

describe Todo::Support::Date do
  let(:now)  { Time.parse('2015-12-01') }
  let(:date) { described_class.new(now) }

  it { expect(date.format('yesterday')).to      eq '2015-11-30' }
  it { expect(date.format('1_day_ago')).to      eq '2015-11-30' }
  it { expect(date.format('3_days_ago')).to     eq '2015-11-28' }

  it { expect(date.format('two weeks ago')).to  eq '2015-11-17' }
  it { expect(date.format('3_weeks_ago')).to    eq '2015-11-10' }

  it { expect(date.format('two months ago')).to eq '2015-10-01' }
  it { expect(date.format('3_months_ago')).to   eq '2015-09-01' }

  it { expect(date.format('one year ago')).to   eq '2014-12-01' }
  it { expect(date.format('2_years_ago')).to    eq '2013-12-01' }

  it { expect(date.format('last_tue')).to       eq '2015-11-24' }
  it { expect(date.format('last_friday')).to    eq '2015-11-27' }
  it { expect(date.format('last_sep')).to       eq '2015-09-01' }
  it { expect(date.format('last_december')).to  eq '2014-12-01' }
end
