module Owners
  # Accepts a single file and returns an array of OWNERS
  # files found when searching recursively up the directory
  # tree.
  #
  # @api private
  class Path
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def configs
      configs = []
      file = @file

      until file == file.dirname
        file = file.dirname
        config = file.join(Owners.file)
        configs << config if config.file?
      end

      configs
    end
  end
end
