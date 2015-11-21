module Owners
  # Traverses up the directory tree starting at a specified
  # file and returns an array of all OWNERS files.
  #
  # @api private
  class Tree
    def initialize(file)
      @file = file
    end

    def owner_files
      parents.each_with_object([]) do |parent, files|
        config = parent.join(Owners.file)
        files << config if config.file?
      end
    end

    private

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
