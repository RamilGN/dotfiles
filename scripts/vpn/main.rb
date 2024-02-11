#!/usr/bin/env ruby

# frozen_string_literal: true

# Starts VPN.
module VPN
  require_relative './secrets'
  require_relative './dns'
  require_relative './connection'
  require_relative './up'

  CONNECTION_NAME = ARGV[0]
  if CONNECTION_NAME.nil? || CONNECTION_NAME.empty?
    warn('You must specify connection name!')
    exit(1)
  end

  up = UP.new(
    connection: Connection.new(name: CONNECTION_NAME),
    dns: DNS.new(Secrets::HOSTS, Secrets::DNS_IPS)
  )
  result = up.call
  puts(result)
end
