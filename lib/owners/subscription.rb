module Owners
  # Represents a single line of an OWNERS file.
  #
  # It contains some useful methods for inspecting the
  # subscriptions themselves like the file, line, and
  # filter, and subscribers.
  #
  # @api public
  class Subscription
    include Comparable

    COMMENT = /^\s*\/\//
    WILDCARD = /.*/

    attr_reader :file, :line, :root, :subscription

    def initialize(subscription, line, config)
      @subscribers, @filter = subscription.split(/\s+/, 2)
      @subscription = subscription
      @line = line
      @file = config.file.sub("./", "")
      @root = config.root
    end

    def <=>(other)
      location <=> other.location
    end

    def filter
      Regexp.new(@filter || WILDCARD)
    end

    def location
      [file, line].join(":")
    end

    def metadata?
      comment? || empty?
    end

    def source
      filter.source
    end

    def subscribed?(path)
      path =~ prefix && relative(path) =~ filter
    end

    def subscribers
      @subscribers.split(",").reject(&:empty?)
    end

    def to_s
      [source, location].join(" ")
    end

    private

    def comment?
      subscription =~ COMMENT
    end

    def empty?
      subscription.strip.empty?
    end

    def prefix
      /\.?\/?#{root}\//
    end

    def relative(path)
      path.sub(prefix, "")
    end
  end
end
