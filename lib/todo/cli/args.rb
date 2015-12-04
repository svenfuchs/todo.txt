require 'optparse'

module Todo
  class Cli
    class Args
      OPTIONS = {
        # file: './todo.txt'
      }

      attr_reader :cmd, :args, :opts

      def initialize(args)
        @opts = OPTIONS
        @args = parser.parse!(args)
        @cmd  = @args.shift || raise('No command given')
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
    end
  end
end
