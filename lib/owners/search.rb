module Owners
  # Accepts an array of file paths and returns an array of
  # owners that have subscribed to the specified files.
  #
  # @api private
  class Search
    RELATIVE = /^\.?\//

    def initialize(files, configs = nil)
      @files = files.map(&:dup)
      @configs = configs
    end

    def owners
      search do |(path, config), results|
        owners = config.owners(path.to_s)
        results.merge(owners) if owners
      end
    end

    private

    def search(&block)
      attempts.each_with_object(SortedSet.new, &block).to_a
    end

    def attempts
      paths.product(configs)
    end

    def configs
      if @configs
        @configs.map { |file, contents| Config.new(file, contents) }
      else
        subscriptions.map { |file| Config.new(file) }
      end
    end

    def subscriptions
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
