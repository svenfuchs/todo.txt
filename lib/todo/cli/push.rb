require 'todo'
require 'todo/cli/cmd'
require 'todo/data/list'
require 'todo/src/idonethis'

module Todo
  class Cli
    class Push < Cmd
      opt '-s', '--since DATE', 'Since date' do |date|
        opts[:since] = normalize_date(date)
      end

      CONFIG = {
        team:     ENV['IDONETHIS_TEAM'],
        username: ENV['IDONETHIS_USERNAME'],
        token:    ENV['IDONETHIS_TOKEN']
      }

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
          Src::Idonethis.new(config, since: since)
        end

        def since
          opts[:since] || DATES[:yesterday]
        end
    end
  end
end
