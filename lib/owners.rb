require 'pathname'
require 'owners/config'
require 'owners/path'
require 'owners/search'
require 'owners/version'

module Owners
  # Accepts a list of file paths and returns an array of
  # owners that have subscribed to the specified files.
  #
  # @api public
  def self.for(*paths)
    paths.map! { |path| Pathname.new(path) }
    Search.new(paths).owners
  end
end
