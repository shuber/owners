module Owners
  # Represents a single OWNERS file.
  #
  # It parses OWNERS files and returns an array of
  # {Subscription} objects is returned for a specified
  # file path.
  #
  # @api private
  class Config
    attr_reader :file, :root

    def self.for(configs)
      configs.map do |file, contents|
        new(file, contents)
      end
    end

    def initialize(file, contents = nil)
      @file = file.to_s
      @contents = contents || file.read
      @root = File.dirname(@file)
    end

    def subscriptions(path, shallow = false)
      search do |subscription, results|
        if subscription.subscribed?(path)
          results << subscription
          return results if shallow
        end
      end
    end

    private

    def search(&block)
      attempts
        .reject(&:metadata?)
        .each_with_object([], &block)
    end

    def attempts
      lines.map.with_index do |subscription, index|
        Subscription.new(subscription, index + 1, self)
      end
    end

    def lines
      @contents.split("\n")
    end
  end
end
