module Owners
  # Parses an OWNERS file and returns an array of owners
  # that have subscribed to a specified file path.
  #
  # @api private
  class Config
    def initialize(file)
      @contents = file.read
      @root = file.dirname.to_s
    end

    def owners(path)
      if path.start_with?(@root)
        relative = path.sub("#{@root}/", "")

        search do |subscription, results|
          owner, pattern = subscription.split(/\s+/, 2)
          regex = Regexp.new(pattern || ".*")
          results << owner if regex =~ relative
        end
      end
    end

    private

    def search(&block)
      subscriptions.each_with_object([], &block)
    end

    def subscriptions
      @contents.split("\n").reject(&:empty?)
    end
  end
end
