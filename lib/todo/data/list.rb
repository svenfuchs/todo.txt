require 'forwardable'
require 'todo'
require 'todo/data/item'
require 'todo/data/parser'
require 'todo/helpers/hash/format'

module Todo
  module Data
    class List < Struct.new(:items)
      class << self
        def parse(lines)
          List.new(lines.map { |line| Item.new(Parser.new(line).parse) })
        end
      end

      extend Forwardable
      include Helpers::Hash::Format

      def_delegators :items, :size, :first

      attr_accessor :max_id

      def initialize(*)
        super
        @max_id = items.map(&:id).map(&:to_i).max || 0
      end

      def toggle(data)
        find(data).toggle
      end

      def select(data)
        self.class.new(items.select { |item| item.matches?(data) })
      end

      def reject(&block)
        self.class.new(items.reject(&block))
      end

      def sort_by(&block)
        self.class.new(items.sort_by(&block))
      end

      def find(data)
        select(data).tap { |list| validate(data, list) }.first
      end

      def ids
        items.map(&:id).compact
      end

      def next_id
        @max_id += 1
      end

      private

        def validate(data, list)
          raise Error.new(MSGS[:item_not_found] % to_pairs(data).join(' ')) if list.size == 0
          raise Error.new(MSGS[:multiple_items] % to_pairs(data).join(' ')) if list.size > 1
        end
    end
  end
end
