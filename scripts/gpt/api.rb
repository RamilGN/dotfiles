# frozen_string_literal: true

require_relative './messages'

module GPT
  class Api
    MODEL = 'gpt-3.5-turbo'

    Messages::NAME_TO_MESSAGE.each_pair do |message_name, message_payload|
      define_method "ask_as_#{message_name}" do |message|
        dup_message_payload = message_payload.dup
        dup_message_payload['model'] = MODEL

        dup_message_payload['messages'] = message_payload['messages'].dup
        dup_message_payload['messages'] << {
          'role' => 'user',
          'content' => message
        }

        ask(dup_message_payload)
      end
    end

    def initialize(client)
      @client = client
    end

    private

    def ask(payload)
      response = client.post(url: Client::URI::COMPLETIONS, payload:)
      JSON.parse(response.body).dig('choices', 0, 'message', 'content')
    rescue OpenURI::HTTPError => e
      body = e.io.read
      puts(JSON.parse(body))
    end

    attr_reader :client
  end
end
