# frozen_string_literal: true

module VPN
  module ConnectionSettings
    DEFAULT_VALUE = ''

    module IPv4
      NEVER_DEFAULT = 'ipv4.never-default'
      ROUTES = 'ipv4.routes'

      DNS = 'ipv4.dns'
      DNS_SEARCH = 'ipv4.dns-search'

      IGNORE_AUTO_ROUTES = 'ipv4.ignore-auto-routes'
      IGNORE_AUTO_DNS = 'ipv4.ignore-auto-dns'
    end
  end
end
