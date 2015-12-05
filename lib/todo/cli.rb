require 'optparse'
require 'todo'
require 'todo/cmd/archive'
require 'todo/cmd/list'
require 'todo/cmd/push'
require 'todo/cmd/toggle'
require 'todo/helpers/string/camelize'

module Todo
  class Cli
    include Helpers::String::Camelize

    attr_reader :cmd, :args, :opts

    def initialize(args)
      @opts = {}
      @args = parser.parse!(args.dup)
      @cmd  = @args.shift || raise('No command given')
    end

    def run
      const.new(args, opts).run
    rescue Error => e
      puts "Error: #{e.message}"
      exit 1
    end

    private

      def parser
        OptionParser.new do |o|
          o.on('-f', '--file FILENAME', 'Filename') do |file|
            opts[:file] = file
          end

          o.on('-s', '--since DATE', 'Since date') do |date|
            opts[:since] = normalize_date(date)
          end

          o.on('-b', '--before DATE', 'Before date') do |date|
            opts[:before] = normalize_date(date)
          end

          o.on('--status STATUS', 'Status') do |status|
            opts[:status] = status
          end
        end
      end

      def normalize_date(date)
        DATES[date.to_sym] ? DATES[date.to_sym] : date
      end

      def const
        Cmd.const_get(camelize(cmd))
      rescue NameError
        fail Error.new(MSGS[:unknown_cmd] % cmd)
      end
  end
end
