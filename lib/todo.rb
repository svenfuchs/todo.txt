module Todo
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
require 'todo/view'
