require 'todo'
require 'todo/helpers/hash/compact'

module Todo
  module Data
    class Parser < Struct.new(:line)
      STATUS = /^(#{STATUSES.values.join('|')}){1}\s*/
      ID     = /\s*\[(\d+)\]/
      TAG    = /\s*([^\s]+):([^\s]+)/

      include Helpers::Hash::Compact

      def parse
        compact(
          id: id,
          text: text,
          status: status,
          tags: tags,
        )
      end

      private

        def status
          STATUSES.invert[line.match(STATUS) && $1]
        end

        def id
          line =~ ID && $1.to_i
        end

        def text
          line.sub(STATUS, '').gsub(ID, '').gsub(TAG, '').rstrip
        end

        def tags
          Hash[line.scan(TAG).map { |key, value| [key.to_sym, value] }]
        end
    end
  end
end
