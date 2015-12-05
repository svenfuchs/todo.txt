module Todo
  module Cmds
    class Base < Struct.new(:args, :opts)
      def text
        args.join(' ') if args.any?
      end

      def input
        @input ||= file? ? file.lines : STDIN.readlines
      end

      def output
        file? ? file.write(list.to_s) : puts(list.to_s)
      end

      def file?
        !!opts[:file]
      end

      def file
        @file ||= File.new(opts[:file])
      end

      def list
        @list ||= Todo::List.new(input)
      end

      def items_by(opts = {})
        items = list.items
        items = by_status(items, opts[:status])   if opts[:status]
        items = done_since(items, opts[:since])   if opts[:since]
        items = done_before(items, opts[:before]) if opts[:before]
        items
      end

      def by_status(items, status)
        items.select { |item| item.status == status.to_sym }
      end

      def done_since(items, date)
        items.select { |item| item.done_date.to_s >= date }
      end

      def done_before(items, date)
        items.select { |item| item.done_date < date }
      end
    end
  end
end
