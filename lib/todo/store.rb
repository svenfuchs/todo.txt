require 'chronic'
require 'faraday'
require 'json'

module Todo
  class Store < Struct.new(:opts)
    URL = 'https://idonethis.com/api/v0.1/dones/'

    def ids
      @ids ||= fetch.map { |item| Item.new(nil, item['raw_text']).id }.compact
    end

    def fetch
      JSON.parse(get.body)['results'] || []
    end

    def push(dones)
      dones.each { |done| post(done) }
    end

    private

    def get
      http.get(URL, owner: opts[:username], team: opts[:team], done_date_after: opts[:since], page_size: 100)
    end

    def post(text)
      response = http.post(URL, raw_text: text, team: opts[:team])
      raise "Could not post to #{URL}: #{response.body}" unless response.status == 201
    end

    def http
      Faraday.new do |c|
        c.use Faraday::Request::UrlEncoded
        c.use Faraday::Adapter::NetHttp
        c.headers['Authorization'] = "Token #{opts[:token]}"
      end
    end
  end
end
