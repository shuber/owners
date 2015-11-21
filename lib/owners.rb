require 'owners/config'
require 'owners/path'
require 'owners/search'
require 'owners/version'

module Owners
  def self.for(*paths)
    Search.new(paths).owners
  end
end
