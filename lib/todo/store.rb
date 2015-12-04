require 'json'
require 'net/http'
require 'uri'

module Todo
  class Store < Struct.new(:opts)
    URL = 'https://idonethis.com/api/v0.1/dones/'

    def known?(item)
      texts.include?(item.text) or ids.include?(item.id)
    end

    def fetch
      JSON.parse(get.body)['results'] || []
    end

    def push(dones)
      dones.each { |done| post(done) }
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

      def get
        http.get(url(owner: opts[:username], team: opts[:team], done_date_after: opts[:since], page_size: 100), headers)
      end

      def post(text)
        request = Net::HTTP::Post.new(url, headers)
        request.form_data = { raw_text: text, team: opts[:team] }
        response = http.request(request)
        raise "Could not post to #{URL}: #{response.body}" unless response.code.to_i == 201
      end

      def headers
        { 'Authorization' => "Token #{opts[:token]}" }
      end

      def http
        Net::HTTP.new(url.host, url.port).tap do |http|
          http.use_ssl = true
        end
      end

      def url(params = nil)
        URI(URL).tap do |url|
          url.query = URI.encode_www_form(params) if params
        end
      end
  end
end
