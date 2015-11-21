module Owners
  # Accepts a single file and returns an array of OWNERS
  # files found when searching recursively up the directory
  # tree.
  #
  # @api private
  class Path
    CONFIG = 'OWNERS'

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def configs
      configs = []
      file = @file

      until file.dirname == file
        file = file.dirname
        config = file.join(CONFIG)

        if config.exist? && !config.directory?
          configs << config
        end
      end

      configs
    end
  end
end
