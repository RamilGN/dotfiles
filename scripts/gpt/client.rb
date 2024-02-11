# frozen_string_literal: true

module GPT
  class Client
    module URI
      BASE = URI('https://api.openai.com')
      COMPLETIONS = BASE.dup.tap { _1.path = '/v1/chat/completions' }
    end

    def initialize(token)
      @token = token
      @client = Net::HTTP.new(URI::BASE.host, URI::BASE.port).tap do |client|
        client.use_ssl = true
      end
    end

    def post(url:, payload:) = send_request(request: Net::HTTP::Post.new(url), payload:)

    private

    attr_reader :client, :token

    def send_request(request:, payload: nil)
      request['Authorization'] = "Bearer #{token}"
      request['Accept'] = 'application/json'

      unless payload.nil?
        request.body = payload.to_json
        request['Content-Type'] = 'application/json'
      end

      client.request(request)
    end
  end
end
