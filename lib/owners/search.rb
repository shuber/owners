module Owners
  # Accepts an array of file paths and returns an array of
  # {Owner} objects that have subscribed to the files.
  #
  # @api private
  class Search
    RELATIVE = /^\.?\//

    def initialize(files, configs = nil)
      @files = files.map(&:dup)
      @configs = configs
    end

    def results
      owners.each do |owner|
        subscriptions.each do |path, subscription|
          if subscription.subscribers.include?(owner)
            owner.subscriptions[path] << subscription
          end
        end
      end
    end

    private

    def owners
      subscribers.map { |subscriber| Owner.new(subscriber) }
    end

    def subscribers
      subscriptions_by_file
        .values
        .flatten
        .flat_map(&:subscribers)
        .uniq
    end

    def subscriptions
      subscriptions_by_file.flat_map do |path, subscriptions|
        [path].product(subscriptions)
      end
    end

    def subscriptions_by_file
      search do |(path, config), results|
        relative = path.sub("./", "")
        results[relative] += config.subscriptions(path)
      end
    end

    def search(&block)
      results = Hash.new { |hash, key| hash[key] = [] }
      attempts.each_with_object(results, &block)
    end

    def attempts
      paths.map(&:to_s).product(configs)
    end

    def configs
      Config.for(@configs || owner_files)
    end

    def owner_files
      trees.flat_map(&:owner_files).uniq
    end

    def trees
      paths.map { |path| Tree.new(path) }
    end

    def paths
      @files.map do |file|
        file.prepend("./") unless file =~ RELATIVE
        Pathname.new(file)
      end
    end
  end
end
