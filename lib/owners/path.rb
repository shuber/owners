module Owners
  class Path
    CONFIG = 'OWNERS'

    def initialize(file)
      @file = file
    end

    def owners
      configs.each_with_object([]) do |config, owners|
        path = @file.sub("#{config.root}/", '')

        config.owners.each do |owner, regexes|
          regexes.each do |regex|
            if path =~ regex
              owners << owner
            end
          end
        end
      end
    end

    private

    def configs
      configs = []
      file = @file

      until ['.', '/'].include?(file)
        file = File.dirname(file)
        config = File.join(file, CONFIG)

        if File.exists?(config) && !File.directory?(config)
          configs << Config.new(config)
        end
      end

      configs
    end
  end
end
