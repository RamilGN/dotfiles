# frozen_string_literal: true

# !/usr/bin/env ruby

require 'net/http'
require 'open-uri'
require 'json'
require 'tempfile'

class GPT
  class Client
    module URI
      BASE = URI('https://api.openai.com')
      COMPLETIONS = BASE.dup.tap { _1.path = '/v1/chat/completions' }
    end

    def initialize(token:)
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

  def initialize(token:)
    @client = Client.new(token:)
  end

  def ask(message:)
    payload = {
      'model' => 'gpt-3.5-turbo',
      'messages' => [
        {
          'role' => 'system',
          'content' => 'You are a helpful assistant.'
        },
        {
          'role' => 'system',
          'content' => 'For every answer, you must give authoritative sources.'
        }
      ]
    }

    payload['messages'] << {
      'role' => 'user',
      'content' => message
    }

    response = client.post(url: Client::URI::COMPLETIONS, payload:)
    JSON.parse(response.body).dig('choices', 0, 'message', 'content')
  rescue OpenURI::HTTPError => e
    body = e.io.read
    puts(JSON.parse(body))
  end

  private

  attr_reader :client
end

TOKEN = ENV['OPENAI_API_KEY']
if TOKEN.empty?
  warn('You must specify token for opeani!')
  exit(1)
end

MESSAGE = ARGV[0...].join(' ')
if MESSAGE.empty?
  warn('You must specify message!')
  exit(1)
end

gpt = GPT.new(token: TOKEN)
answer = gpt.ask(message: MESSAGE)
file = Tempfile.new('my-gpt')

begin
  file.write(answer)
  file.flush
  system("bat --paging=never --style=grid -l md #{file.path}")
ensure
  file.close
  file.unlink
end
