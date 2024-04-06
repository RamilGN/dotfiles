# frozen_string_literal: true

require 'json'
require 'resolv'
require_relative './dns'
require_relative './secrets'

amensia_ips = []

VPN::Secrets::HOSTS.each do |host|
  puts host

  ips = Resolv.getaddresses(host)

  ips.each do |ip|
    amensia_ips << { 'hostname' => host, 'ip' => ip }
  end
end

VPN::Secrets::DNS_IPS.each do |ip|
  amensia_ips << { 'hostname' => 'dns', 'ip' => ip }
end

File.open('/tmp/amnesia.json', 'w') { _1.write(JSON.dump(amensia_ips)) }
