require 'todo/helpers/hash/slice'

module Todo
  module Data
    class Matcher
      ATTRS = [:id, :text, :projects, :status, :after, :before]

      include Helpers::Hash::Slice

      attr_reader :item, :data

      def initialize(item, data)
        @item = item
        @data = slice(data, *ATTRS)
      end

      def matches?
        return true if data.empty?
        data[:id] ? match_id : match_data
      end

      private

        def match_data
          data.keys.inject(true) do |result, key|
            result && send(:"match_#{key}")
          end
        end

        def match_id
          item.id.to_i == data[:id].to_i
        end

        def match_text
          item.text.include?(data[:text])
        end

        def match_projects
          item.projects & data[:projects] == data[:projects]
        end

        def match_status
          item.status && item.status.to_sym == normalize_status(data[:status].to_sym)
        end

        def match_after
          item.done_date.to_s >= data[:after].to_s
        end

        def match_before
          item.done_date.to_s < data[:before].to_s
        end

        def normalize_status(status)
          status == :pending ? :pend : status
        end
    end
  end
end
