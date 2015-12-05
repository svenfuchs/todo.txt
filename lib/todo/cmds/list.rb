require 'todo/cmds/base'

module Todo
  module Cmds
    class List < Base
      def run
        items = items_by(opts)
        items = items.sort_by(&:done_date)
        puts items.map { |item| [item.done_date, item.text].join(' ') }
      end
    end
  end
end
