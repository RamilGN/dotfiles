# frozen_string_literal: true

require 'resolv'

module VPN
  # DNS actions on hosts.
  class DNS
    # @param hosts [Array<String>]
    # @param name_servers [Array<String>]
    def initialize(hosts, name_servers)
      @hosts = hosts
      @name_servers = name_servers
    end

    # @return [Array<String>]
    def resolve_ips
      hosts
        .flat_map { Resolv.getaddresses(_1) }
        .concat(name_servers)
        .tap(&:uniq!)
    end

    # @return [String]
    def resolve_ips_as_string(sep: ', ')
      resolve_ips.join(sep)
    end

    # @return [String]
    def name_servers_as_string(sep: ', ')
      name_servers.join(sep)
    end

    private

    attr_reader :hosts, :name_servers
  end
end
