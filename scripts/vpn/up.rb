# frozen_string_literal: true

require_relative './connection_settings'

module VPN
  # Up VPN with predefined settings.
  class UP
    # @param connection [Connection]
    # @param dns [DNS]
    def initialize(connection:, dns:)
      @connection = connection
      @dns = dns
    end

    # @return [Connection]
    def call
      reset_settings
      update_dns_settings
      reload_connection
      update_connection_ips_settings(dns.resolve_ips_as_string)
      reload_connection
    end

    private

    # @return [String]
    def reload_connection
      connection.reload
    end

    # @return [Connection]
    def update_connection_ips_settings(ips)
      connection.modify(setting: ConnectionSettings::IPv4::IGNORE_AUTO_ROUTES, value: true)
      connection.modify(setting: ConnectionSettings::IPv4::ROUTES, value: ips)
      connection.modify(setting: ConnectionSettings::IPv4::NEVER_DEFAULT, value: true)
    end

    # I want get ips through non automatic dns.
    # @return [Connection]
    def update_dns_settings
      connection.modify(setting: ConnectionSettings::IPv4::NEVER_DEFAULT, value: false)
      connection.modify(setting: ConnectionSettings::IPv4::DNS_SEARCH, value: '~.')
      connection.modify(setting: ConnectionSettings::IPv4::DNS, value: dns.name_servers_as_string)
      connection.modify(setting: ConnectionSettings::IPv4::IGNORE_AUTO_DNS, value: true)
    end

    # @return [Connection]
    def reset_settings
      connection.modify(setting: ConnectionSettings::IPv4::NEVER_DEFAULT,      value: ConnectionSettings::DEFAULT_VALUE)
      connection.modify(setting: ConnectionSettings::IPv4::DNS_SEARCH,         value: ConnectionSettings::DEFAULT_VALUE)
      connection.modify(setting: ConnectionSettings::IPv4::DNS,                value: ConnectionSettings::DEFAULT_VALUE)
      connection.modify(setting: ConnectionSettings::IPv4::IGNORE_AUTO_DNS,    value: ConnectionSettings::DEFAULT_VALUE)
      connection.modify(setting: ConnectionSettings::IPv4::ROUTES,             value: ConnectionSettings::DEFAULT_VALUE)
      connection.modify(setting: ConnectionSettings::IPv4::IGNORE_AUTO_ROUTES, value: ConnectionSettings::DEFAULT_VALUE)
    end

    attr_reader :connection, :dns
  end
end
