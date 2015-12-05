require 'todo/cli/args'
require 'todo/cmds'
require 'todo/helpers/string'

module Todo
  class Cli
    class << self
      include Helpers::String

      def run(args)
        args = Args.new(ARGV.map(&:dup))
        cmd(args)
      rescue Error => e
        puts "Error: #{e.message}"
        exit 1
      end

      def cmd(args)
        const = Cmds.const_get(camelize(args.cmd))
        cmd = const.new(args.args, args.opts)
        cmd.run
      end
    end
  end
end
