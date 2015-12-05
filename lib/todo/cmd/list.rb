require 'todo/cmd/base'
require 'todo/data/list'

module Todo
  module Cmd
    class List < Base
      def run
        out.write(render(list.items, [:done_date, :text]))
      end

      private

        def list
          list = Data::List.parse(io.read)
          list = list.select(slice(opts, :id, :status, :text, :before, :since))
          list.sort_by { |item| item.done_date.to_s }
        end

        def out
          Src::Io.new(out: opts[:out])
        end
    end
  end
end
