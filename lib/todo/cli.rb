require 'optparse'
require 'todo'
require 'todo/cli/archive'
require 'todo/cli/list'
require 'todo/cli/push'
require 'todo/cli/toggle'
require 'todo/helpers/string/camelize'

module Todo
  class Cli
    include Helpers::String::Camelize

    attr_reader :cmd, :args, :opts

    def initialize(args)
      @args = args
      @cmd  = @args.shift || raise('No command given')
    end

    def run
      args, opts = const.parse(self.args)
      const.new(args, opts).run
    rescue Error => e
      abort "Error: #{e.message}"
    end

    private

      def normalize_date(date)
        DATES[date.to_sym] ? DATES[date.to_sym] : date
      end

      def const
        @const ||= Cli.const_get(camelize(cmd))
      rescue NameError
        fail Error.new(MSGS[:unknown_cmd] % cmd)
      end
  end
end
