module Owners
  # Parses an OWNERS file and returns a hash of subscribers
  # along with the files and patterns that each subscribes to.
  #
  # @api private
  class Config
    def initialize(file)
      @config = file.read
      @root = file.dirname.to_s
    end

    def owners(path)
      if path.start_with?(@root)
        relative = path.sub("#{@root}/", '')

        search do |subscription, results|
          owner, pattern = subscription.split(/\s+/, 2)
          regex = Regexp.new(pattern || '.*')
          results << owner if regex =~ relative
        end
      end
    end

    private

    def search(&block)
      subscriptions.each_with_object([], &block)
    end

    def subscriptions
      @config.split("\n").reject(&:empty?)
    end
  end
end
