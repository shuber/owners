module Owners
  # Represents a single line of an OWNERS file.
  #
  # @api public
  class Subscription
    extend Forwardable

    COMMENT = /^\s*\/\//
    WILDCARD = /.*/

    attr_reader :line

    def_delegators :@config, :file, :root

    def initialize(subscription, line, config)
      @subscribers, @filter = subscription.split(/\s+/, 2)
      @subscription = subscription
      @line = line
      @config = config
    end

    def comment?
      @subscription =~ COMMENT
    end

    def empty?
      @subscription.strip.empty?
    end

    def filter
      Regexp.new(@filter || WILDCARD)
    end

    def metadata?
      comment? || empty?
    end

    def prefix
      /\.?\/?#{root}\//
    end

    def relative(path)
      path.sub(prefix, "")
    end

    def subscribed?(path)
      path =~ prefix && relative(path) =~ filter
    end

    def subscribers
      @subscribers.split(",").reject(&:empty?)
    end
  end
end
