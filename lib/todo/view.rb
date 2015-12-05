require 'todo'
require 'todo/helpers/hash/format'
require 'todo/helpers/object/presence'

module Todo
  class View < Struct.new(:items, :cols)
    COLS = [:status, :text, :tags, :id]

    include Helpers::Hash::Format, Helpers::Object::Presence

    def render
      items.map { |item| format(item) }
    end

    private

      def format(item)
        cols.map { |col| format_col(col, item.send(col)) }.compact.join(' ')
      end

      def format_col(col, value)
        send(:"format_#{col}", value) if present?(value)
      end

      def format_status(status)
        STATUSES[status]
      end

      def format_id(id)
        "[#{id}]"
      end

      def format_text(text)
        text
      end

      def format_done_date(date)
        date
      end

      def format_tags(tags)
        to_pairs(tags, ':') if tags.any?
      end

      def cols
        super || COLS
      end
  end
end
