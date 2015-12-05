require 'todo/cmds/archive'
require 'todo/cmds/list'
require 'todo/cmds/push'
require 'todo/store'

module Todo
  module Cmds
    class Pend < Base
      def run
        list.pend(text)
        output
      end
    end

    class Done < Base
      def run
        raise 'No item given' unless text
        list.done(text)
        output
      end
    end

    class Toggle < Base
      def run
        list.toggle(text)
        output
      end
    end
  end
end
