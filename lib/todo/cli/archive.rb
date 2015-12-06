require 'todo/cli/cmd'
require 'todo/data/list'
require 'todo/src/file'

module Todo
  class Cli
    class Archive < Cmd
      opt '-a', '--archive FILENAME', 'Archive filename' do |opts, file|
        opts[:archive] = file
      end

      opt '-b', '--before DATE', 'Before date' do |opts, date|
        opts[:before] = date
      end

      def run
        items = list.select(status: :done, before: before).items
        archive.write(format(items))
        io.write(format(list.items - items))
      end

      private

        def list
          @list ||= Data::List.parse(io.read)
        end

        def archive
          @archive ||= Src::File.new(archive_path, mode: 'a+')
        end

        def archive_path
          opts[:archive] || File.expand_path('../archive.txt', opts[:file])
        end

        def before
          opts[:before] || Support::Date.new.format(:two_weeks_ago)
        end
    end
  end
end
