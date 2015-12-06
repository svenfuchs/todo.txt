require 'todo/helpers/hash/slice'
require 'todo/src/file'
require 'todo/src/io'
require 'todo/support/options_parser'
require 'todo/support/date'
require 'todo/format'

module Todo
  class Cli
    class Cmd < Struct.new(:args, :opts)
      extend Support::OptionsParser
      include Helpers::Hash::Slice

      opt '-f', '--file FILENAME', 'Filename' do |opts, file|
        opts[:file] = file
      end

      def initialize(args, opts)
        opts = normalize_dates(opts)
        super
      end

      def io
        if opts[:file]
          Src::File.new(opts[:file])
        else
          Src::Io.new(slice(opts, :in, :out))
        end
      end

      def format(list, opts = {})
        Format.new(list, opts).apply
      end

      def normalize_dates(opts)
        [:before, :after].inject(opts) do |opts, key|
          opts[key] = normalize_date(opts[key]) if opts[key]
          opts
        end
      end

      def normalize_date(date)
        Support::Date.new.format(date)
      end

      # TODO how to test if stdin is attached?
      #
      # def stdin?
      #   !$stdin.eof? # blocks
      # end
      #
      # def stdin?
      #   $stdin.read_nonblock(1)
      #   $stdin.seek(-1) # can't seek on stdin?
      #   true
      # rescue IO::EAGAINWaitReadable
      #   false
      # end
    end
  end
end
