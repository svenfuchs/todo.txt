require 'todo/data/matcher'

module Todo
  module Data
    class Item < Struct.new(:data)
      PROJECT = /\s*\+([\w\-]+)/

      def initialize(data)
        data[:tags] ||= {}
        super
      end

      [:id, :status, :tags, :text].each do |name|
        define_method(name) { data[name] }
      end

      def done?
        status == :done
      end

      def due_date
        tags[:due].to_s if tags[:due]
      end

      def done_date
        tags[:done].to_s if tags[:done]
      end

      def projects
        @projects ||= text.scan(PROJECT).flatten
      end

      def toggle
        done? ? pend : done
      end

      def matches?(data)
        Matcher.new(self, data).matches?
      end

      private

        def done
          data[:status] = :done
          data[:tags][:done] = today
        end

        def pend
          data[:status] = :pend
          data[:tags].delete(:done)
        end

        def today
          Time.now.strftime('%Y-%m-%d')
        end
    end
  end
end
