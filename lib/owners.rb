require "pathname"
require "set"
require "thor"
require_relative "owners/cli"
require_relative "owners/config"
require_relative "owners/search"
require_relative "owners/tree"
require_relative "owners/version"

module Owners
  class << self
    # @api public
    attr_writer :file

    # The name of the file used to store ownership
    # subscriptions. Defaults to OWNERS.
    #
    # @api public
    def file
      @file ||= "OWNERS"
    end

    # Accepts a list of file paths and returns an array of
    # owners that have subscribed to the specified files.
    #
    # @api public
    def for(*files)
      Search.new(files).owners
    end
  end
end
