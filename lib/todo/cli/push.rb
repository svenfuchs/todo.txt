require 'todo'
require 'todo/cli/cmd'
require 'todo/data/list'
require 'todo/src/idonethis'

module Todo
  class Cli
    class Push < Cmd
      opt '-a', '--after DATE', 'After date' do |opts, date|
        opts[:after] = date
      end

      opt '-s', '--since DATE', 'Since date' do |opts, date|
        opts[:after] = date
      end

      CONFIG = {
        team:     ENV['IDONETHIS_TEAM'],
        username: ENV['IDONETHIS_USERNAME'],
        token:    ENV['IDONETHIS_TOKEN']
      }

      def run
        lines = format(list, format: [:text, :tags, :id])
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
          opts[:since] || Support::Dates.new.format(:yesterday)
        end
    end
  end
end
