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
      raw = @paths.each_with_object([]) do |path, owners|
        path = Path.new(path)

        path.configs.each do |config|
          config = Config.new(config)

          relative = path.file.sub("#{config.root}/", '')

          config.subscribers.each do |owner, regexes|
            regexes.each do |regex|
              if relative.to_s =~ regex
                owners << owner
              end
            end
          end
        end
      end
      
      raw.uniq.sort
    end
  end
end
