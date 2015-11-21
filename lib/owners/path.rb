module Owners
  class Path
    CONFIG = 'OWNERS'

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def configs
      configs = []
      file = @file

      until ['.', '/'].include?(file)
        file = File.dirname(file)
        config = File.join(file, CONFIG)

        if File.exist?(config) && !File.directory?(config)
          configs << Config.new(config)
        end
      end

      configs
    end
  end
end
