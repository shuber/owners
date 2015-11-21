module Owners
  # Parses an OWNERS file and returns a hash of subscribers
  # along with the files and patterns that each subscribes to.
  #
  # @api private
  class Config
    attr_reader :root

    def initialize(file)
      @config = file.read
      @root = file.dirname
    end

    def subscribers
      subscriptions.each_with_object({}) do |line, hash|
        owner, path = line.split(/\s+/, 2).push('.*')
        hash[owner] ||= []
        hash[owner] << Regexp.new(path)
      end
    end

    private

    def subscriptions
      @config.split("\n").reject(&:empty?)
    end
  end
end
