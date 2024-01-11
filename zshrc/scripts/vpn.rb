#!/usr/bin/env ruby

# frozen_string_literal: true

require 'resolv'
require 'open3'
require_relative './secrets'

class Connection
  class Error < StandardError; end

  module IPv4
    NEVER_DEFAULT = 'ipv4.never-default'
    ROUTES = 'ipv4.routes'

    DNS = 'ipv4.dns'
    DNS_SEARCH = 'ipv4.dns-search'

    IGNORE_AUTO_ROUTES = 'ipv4.ignore-auto-routes'
    IGNORE_AUTO_DNS = 'ipv4.ignore-auto-dns'
  end

  def initialize(name:)
    @name = name
    @cmd = 'nmcli connection'
  end

  def modify(setting:, value:)
    result, error, status = Open3.capture3("#{cmd} modify #{name} #{setting} #{value}")
    raise Error, error unless status.success?

    result
  end

  def up
    result, error, status = Open3.capture3("#{cmd} up #{name}")
    raise Error, error unless status.success?

    result
  end

  def down
    result, error, status = Open3.capture3("#{cmd} down #{name}")
    raise Error, error unless status.success?

    result
  end

  def reload
    begin
      down
    rescue Error
      puts('Connection is not active, activating...')
    end

    up
  end

  def show
    result, error, status = Open3.capture3("#{cmd} show #{name}")
    raise Error, error unless status.success?

    result
  end

  private

  attr_reader :name, :cmd
end

def resolve_ips(hosts:)
  hosts
    .flat_map { Resolv.getaddresses(_1) }
    .concat(Secrets::Connection::DNS_IPS)
    .tap(&:uniq!)
    .join(', ')
end

CONNECTION_NAME = ARGV[0]
if CONNECTION_NAME.nil? || CONNECTION_NAME.empty?
  warn('You must specify connection name!')
  exit(1)
end

connection = Connection.new(name: CONNECTION_NAME)

# Сбрасываем все нужные настройки.
connection.modify(setting: Connection::IPv4::NEVER_DEFAULT,      value: Secrets::Connection::DEFAULT_VALUE)
connection.modify(setting: Connection::IPv4::DNS_SEARCH,         value: Secrets::Connection::DEFAULT_VALUE)
connection.modify(setting: Connection::IPv4::DNS,                value: Secrets::Connection::DEFAULT_VALUE)
connection.modify(setting: Connection::IPv4::IGNORE_AUTO_DNS,    value: Secrets::Connection::DEFAULT_VALUE)
connection.modify(setting: Connection::IPv4::ROUTES,             value: Secrets::Connection::DEFAULT_VALUE)
connection.modify(setting: Connection::IPv4::IGNORE_AUTO_ROUTES, value: Secrets::Connection::DEFAULT_VALUE)

# Получаем все необходимые ip через "неавтоматический" DNS.
connection.modify(setting: Connection::IPv4::NEVER_DEFAULT, value: false)
connection.modify(setting: Connection::IPv4::DNS_SEARCH, value: '~.')
connection.modify(setting: Connection::IPv4::DNS, value: Secrets::Connection::DNS_IPS.join(','))
connection.modify(setting: Connection::IPv4::IGNORE_AUTO_DNS, value: true)
connection.reload

# Используем VPN только для этих ip.
ips = "'#{resolve_ips(hosts: Secrets::Connection::HOSTS)}'"
connection.modify(setting: Connection::IPv4::IGNORE_AUTO_ROUTES, value: true)
connection.modify(setting: Connection::IPv4::ROUTES, value: ips)
connection.modify(setting: Connection::IPv4::NEVER_DEFAULT, value: true)

puts(connection.reload)
