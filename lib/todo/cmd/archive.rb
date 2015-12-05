require 'todo/cmd/base'

module Todo
  module Cmd
    class Archive < Base
      def run
        items = list.select(status: :done, before: before).items
        archive.write(render(items))
        io.write(render(list.items - items))
      end

      private

        def list
          @list ||= Data::List.parse(io.read)
        end

        def archive
          @archive ||= Src::File.new(archive_path, mode: 'a+')
        end

        def archive_path
          File.expand_path('../archive.txt', opts[:file])
        end

        def before
          opts[:before] || DATES[:two_weeks_ago]
        end
    end
  end
end
