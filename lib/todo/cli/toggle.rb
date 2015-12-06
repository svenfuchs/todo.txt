require 'todo/cli/cmd'
require 'todo/data/list'
require 'todo/data/parser'

module Todo
  class Cli
    class Toggle < Cmd
      opt '-i', '--id ID', 'ID' do |opts, id|
        opts[:id] = id
      end

      opt '-t', '--text TEXT', 'Text' do |opts, text|
        opts[:text] = text
      end

      def run
        list = Data::List.parse(io.read)
        list.toggle(data)
        io.write(format(list.items))
      end

      private

        def data
          data = Data::Parser.new(args.first.to_s).parse
          data = data.merge(slice(opts, :id, :text))
          slice(data, :id, :text)
        end
    end
  end
end
