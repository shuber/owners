require 'pathname'
require 'owners/config'
require 'owners/path'
require 'owners/search'
require 'owners/version'

module Owners
  class << self
    # @api public
    attr_writer :file

    # The name of the file used to store ownership
    # subscriptions. Defaults to OWNERS.
    #
    # @api public
    def file
      @file ||= 'OWNERS'
    end

    # Accepts a list of file paths and returns an array of
    # owners that have subscribed to the specified files.
    #
    # @api public
    def for(*paths)
      Search.new(paths).owners
    end
  end
end
