# frozen_string_literal: true

# !/usr/bin/env ruby

require 'net/http'
require 'open-uri'
require 'json'
require 'tempfile'
require_relative './client'
require_relative './api'

module GPT
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

  gpt_client = GPT::Client.new(TOKEN)
  gpt = GPT::Api.new(gpt_client)
  answer = gpt.ask_as_assistant(MESSAGE)
  file = Tempfile.new('my-gpt')

  begin
    file.write(answer)
    file.flush
    system("bat --paging=never --style=grid -l md #{file.path}")
  ensure
    file.close
    file.unlink
  end
end
