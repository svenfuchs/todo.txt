require 'time'
require 'support/io'

NOW = Time.parse('2015-12-01 00:02:00 +0200')

RSpec.configure do |c|
  c.mock_with :mocha
  c.before { Time.stubs(:now).returns(NOW) }
end
