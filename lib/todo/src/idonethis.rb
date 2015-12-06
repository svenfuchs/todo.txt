require 'json'
require 'todo/support/http'

module Todo
  module Src
    class Idonthis < Struct.new(:config, :opts)
      URL = 'https://idonethis.com/api/v0.1/dones/'

      def include?(item)
        texts.include?(item.text) or ids.include?(item.id)
      end

      def write(lines)
        lines.each { |line| post(line) }
      end

      private

        def texts
          items.map(&:text)
        end

        def ids
          items.map(&:id).compact
        end

        def items
          @items ||= fetch.map { |item| Item.new(nil, item['raw_text']) }
        end

        def fetch
          JSON.parse(get.body)['results'] || []
        end

        def get
          Http.new(URL, headers: headers, params: params).get
        end

        def post(text)
          Http.new(URL, headers: headers).post(raw_text: text, team: config[:team])
        end

        def headers
          { 'Authorization' => "Token #{config[:token]}" }
        end

        def params
          { owner: config[:username], team: config[:team], done_date_after: opts[:since], page_size: 100 }
        end
    end
  end
end
