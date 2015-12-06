require 'todo/cli/cmd'
require 'todo/data/list'

module Todo
  class Cli
    class List < Cmd
      opt '--format FORMAT', 'Format' do |opts, format|
        opts[:format] = format
      end

      opt '-a', '--after DATE', 'After date' do |opts, date|
        opts[:after] = date
      end

      opt '-s', '--since DATE', 'Since date' do |opts, date|
        opts[:after] = date
      end

      opt '-b', '--before DATE', 'Before date' do |opts, date|
        opts[:before] = date
      end

      opt '--status STATUS', 'Status' do |opts, status|
        opts[:status] = status
      end

      opt '-p', '--project PROJECT', 'Project' do |opts, project|
        opts[:projects] ||= []
        opts[:projects] << project
      end

      opt '-t', '--text TEXT', 'Text' do |opts, text|
        opts[:text] = text
      end

      def run
        out.write(format(list, format: opts[:format] || :short))
      end

      private

        def list
          list = Data::List.parse(io.read)
          list = list.select(data)
          list.sort_by { |item| item.done_date.to_s }
        end

        def data
          data = slice(opts, :status, :before, :after, :projects, :text)
          data = data.merge(text: args.first) if args.first
          data
        end

        def out
          Src::Io.new(out: opts[:out])
        end
    end
  end
end
