require 'todo/cli/cmd'
require 'todo/data/list'

module Todo
  class Cli
    class List < Cmd
      opt '-s', '--since DATE', 'Since date' do |date|
        opts[:since] = normalize_date(date)
      end

      opt '-b', '--before DATE', 'Before date' do |date|
        opts[:before] = normalize_date(date)
      end

      opt '--status STATUS', 'Status' do |status|
        opts[:status] = status
      end

      def run
        out.write(render(list.items, [:done_date, :text]))
      end

      private

        def list
          list = Data::List.parse(io.read)
          list = list.select(data)
          list.sort_by { |item| item.done_date.to_s }
        end

        def data
          data = slice(opts, :status, :before, :since)
          # data = data.merge(text: args.first)
          data
        end

        def out
          Src::Io.new(out: opts[:out])
        end
    end
  end
end
