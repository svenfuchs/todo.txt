module Todo
  DATES = {
    two_weeks_ago: (Time.now - 60 * 60 * 24 * 14).strftime('%Y-%m-%d'),
    yesterday:     (Time.now - 60 * 60 * 24).strftime('%Y-%m-%d'),
    today:         Time.now.strftime('%Y-%m-%d')
  }

  STATUSES = {
    done: 'x',
    pend: '-'
  }

  Error = Class.new(StandardError)
end

require 'todo/cli'
require 'todo/file'
require 'todo/item'
require 'todo/list'
