module Owners
  # Parses an OWNERS file and returns a hash of subscribers
  # with the files and patterns that each subscribes to.
  #
  # @api private
  class Config
    attr_reader :root

    def initialize(file)
      @config = File.read(file)
      @root = File.dirname(file)
    end

    def owners
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
