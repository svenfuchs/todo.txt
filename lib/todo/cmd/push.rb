require 'todo'
require 'todo/cmd/base'
require 'todo/data/list'
require 'todo/src/idonethis'

module Todo
  module Cmd
    class Push < Base
      def run
        lines = render(list.items, [:text, :tags, :id])
        src.write(lines)
        io.write(lines)
      end

      private

        def list
          list = Data::List.parse(io.read)
          list = list.select(status: :done, since: since)
          list.reject { |item| store.include?(item) }
        end

        def src
          Src::Idonethis.new(since: since)
        end

        def since
          opts[:since] || DATES[:yesterday]
        end
    end
  end
end
