module Todo
  class List < Struct.new(:lines)
    LINE = /^(#{STATUSES.values.join('|')}){1}\s+[^\s]+/

    MSGS = {
      item_not_found: 'Could not find item for: %s',
      multiple_items: 'Multiple items found for: %s'
    }

    attr_accessor :max_id

    def initialize(*)
      super
      @max_id = items.map(&:id).map(&:to_i).max || 0
    end

    [:pend, :done, :toggle].each do |name|
      define_method(name) do |string|
        find(string).send(name)
        update
        lines
      end
    end

    def items
      @items ||= lines.map { |line| Item.new(self, line) if line =~ LINE }.compact.reverse
    end

    def ids
      items.map(&:id).compact
    end

    def next_id
      @max_id += 1
    end

    def to_s
      lines.join("\n")
    end

    private

      def find(string)
        matches = items.select { |item| item.line.include?(string.strip) }
        validate(string, matches)
        matches.first
      end

      def update
        items.each { |item| item.line.replace(item.to_s) }
      end

      def validate(string, items)
        raise Error.new(MSGS[:item_not_found] % string) if items.size == 0
        raise Error.new(MSGS[:multiple_items] % string) if items.size > 1
      end
  end
end
