require 'todo/cmds/base'

module Todo
  module Cmds
    class Archive < Base
      def run
        write(items)
        list.lines.delete_if { |line| archived_ids.include?(Item.new(nil, line).id) }
        output
      end

      def write(items)
        ::File.open(archive_filename, 'a+') do |f|
          f << items.map(&:line).join("\n")
        end
      end

      # def lines
      #   @lines ||= items.map { |item| item.line }
      # end

      def items
        @items ||= items_by(status: :done, before: before)
      end

      def archived_ids
        @archive ||= Todo::List.new(read).ids
      end

      def read
        ::File.exists?(archive_filename) ? ::File.read(archive_filename).split("\n") : []
      end

      def archive_filename
        ::File.expand_path('../archive.txt', opts[:file].to_s)
      end

      def before
        opts[:before] || DATES[:two_weeks_ago]
      end
    end
  end
end
