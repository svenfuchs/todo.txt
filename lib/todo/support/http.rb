require 'net/http'
require 'uri'

module Todo
  module Support
    class Http
      attr_reader :uri, :headers

      def initialize(url, opts)
        @uri = URI(url).tap { |url| url.query = URI.encode_www_form(opts[:params] || {}) }
        @headers = opts[:headers] || {}
      end

      def get
        client = Net::HTTP.new(url.host, url.port)
        client.use_ssl = true
        response = client.get(uri, headers)
        raise "Failed to get #{url.to_s}" unless response.code.to_s[0] == '2'
        response
      end

      def post(data)
        request = Net::HTTP::Post.new(url, headers)
        request.form_data = data
        response = http.request(request)
        raise "Failed to post to #{url.to_s}: #{response.body}" unless response.code.to_s[0] == '2'
        response
      end
    end
  end
end
