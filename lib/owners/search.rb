module Owners
  class Search
    def initialize(paths)
      @paths = paths
    end

    def owners
      paths.flat_map(&:owners).flatten.uniq.sort
    end

    private

    def paths
      @paths.map { |path| Path.new(path) }
    end
  end
end
