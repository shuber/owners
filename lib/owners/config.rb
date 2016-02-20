module Owners
  # Parses an OWNERS file and returns an array of owners
  # that have subscribed to a specified file path.
  #
  # @api private
  class Config
    COMMENT = /^\s*\/\//

    def initialize(file, contents = nil)
      @contents = contents || file.read
      @root = File.dirname(file.to_s)
    end

    def owners(path)
      if path =~ prefix
        relative = path.sub(prefix, "")

        search do |subscription, results|
          owners = subscribers(relative, subscription)
          results.push(*owners)
        end
      end
    end

    private

    def prefix
      /\.?\/?#{@root}\//
    end

    def search(&block)
      subscriptions.each_with_object([], &block)
    end

    def subscriptions
      @contents.split("\n").reject do |subscription|
        subscription.empty? || subscription =~ COMMENT
      end
    end

    def subscribers(path, subscription)
      subscribers, pattern = subscription.split(/\s+/, 2)
      regex = Regexp.new(pattern || ".*")

      subscribers.split(",").tap do |owners|
        owners.clear unless regex =~ path
      end
    end
  end
end
