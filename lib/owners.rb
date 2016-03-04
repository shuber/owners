require "delegate"
require "pathname"
require "set"
require "thor"
require "timeout"
require_relative "owners/cli"
require_relative "owners/config"
require_relative "owners/owner"
require_relative "owners/search"
require_relative "owners/subscription"
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

    # Accepts a git ref and an optional base ref and returns
    # an array of owners that have subscribed to the changes.
    #
    # The base ref defaults to "master".
    #
    # @api public
    def for_diff(ref, base = "master")
      files = `git diff --name-only #{base}...#{ref}`.split("\n")

      # TODO: why doesn't this work? It works in the command line...
      # blobs = `git ls-tree -r #{ref} | **/#{file}`.split("\n")
      blobs = `git ls-tree -r #{ref} | egrep "(^|/)#{file}$"`.split("\n")

      configs = blobs.reduce({}) do |hash, line|
        _, _, sha, file = line.split(/\s+/, 4)
        contents = `git show #{sha}`
        hash.update(file => contents)
      end

      Search.new(files, configs).owners
    end

    # Accepts a list of file paths and returns an array of
    # the ones that do not have subscribed owners.
    #
    # @api public
    def missing_for(*files)
      paths = Search.new(files, shallow: true).paths
      files - paths
    end
  end
end
