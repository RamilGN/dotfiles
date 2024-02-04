# frozen_string_literal: true

require 'open3'

module VPN
  # Represents connection in nmcli.
  # `nmcli connection show connection_name`
  class Connection
    class Error < StandardError; end

    # @param name [String]
    def initialize(name:)
      @name = name
      @cmd = 'nmcli connection'
    end

    # @param setting [String]
    # @param value [String]
    # @return [Connection]
    def modify(setting:, value:)
      raise_error_unless_success { Open3.capture3("#{cmd} modify #{name} #{setting} '#{value}'") }
      self
    end

    # @return [String]
    def up
      raise_error_unless_success { Open3.capture3("#{cmd} up #{name}") }
    end

    # @return [String]
    def down
      raise_error_unless_success { Open3.capture3("#{cmd} down #{name}") }
    end

    # @return [String]
    def reload
      begin
        down
      rescue Error
        puts('Connection is not active, activating...')
      end

      up
    end

    # @return [Array<(String, String, Process::Status)>]
    def show
      raise_error_unless_success { Open3.capture3("#{cmd} show #{name}") }
    end

    # @return [Array<(String, String, Process::Status)>]
    def to_s
      show
    end

    private

    # @!attribute [r] name
    #   @return [String]
    # @!attribute [r] name
    #   @return [String]
    attr_reader :name, :cmd

    # @raise [Error]
    # @yieldreturn [Array<(String, String, Process::Status)>]
    def raise_error_unless_success
      result, error, status = yield
      raise Error, error unless status.success?

      result
    end
  end
end
