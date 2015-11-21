module Owners
  # Accepts an array of file paths and returns an array of
  # owners that have subscribed to the specified files.
  #
  # @api private
  class Search
    def initialize(paths)
      @paths = paths
    end

    def owners
      search do |(path, config), results|
        owners = config.owners(path.to_s)
        results.merge(owners) if owners
      end
    end

    private

    def search(&block)
      paths.product(configs).each_with_object(SortedSet.new, &block).to_a
    end

    def configs
      directories.uniq.each_with_object([]) do |dir, configs|
        path = dir.join(Owners.file)
        configs << Config.new(path) if path.file?
      end
    end

    def directories
      paths.flat_map { |path| Tree.new(path).parents }
    end

    def paths
      @paths.map { |path| Pathname.new(path) }
    end
  end
end
