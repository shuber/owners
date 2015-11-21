module Owners
  # Traverses up the directory tree starting at a specified
  # file and returns an array of all parent directories.
  #
  # @api private
  class Tree
    def initialize(file)
      @file = file
    end

    def parents
      parents = []
      file = @file

      until file == file.dirname
        file = file.dirname
        parents << file
      end

      parents
    end
  end
end
