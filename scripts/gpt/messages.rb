# frozen_string_literal: true

module GPT
  module Messages
    HELPFUL_ASSISTANT = {
      'messages' => [
        {
          'role' => 'system',
          'content' => 'You are a helpful assistant.'
        }.freeze,
        {
          'role' => 'system',
          'content' => 'For every answer, you must give authoritative sources.'
        }.freeze
      ].freeze
    }.freeze

    NAME_TO_MESSAGE = {
      assistant: HELPFUL_ASSISTANT
    }.freeze
  end
end
