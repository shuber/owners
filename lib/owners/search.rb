module Owners
  class Search
    def initialize(paths)
      @paths = paths
    end

    def owners
      raw = @paths.each_with_object([]) do |path, owners|
        path = Path.new(path)

        path.configs.each do |config|
          relative = path.file.sub("#{config.root}/", '')

          config.owners.each do |owner, regexes|
            regexes.each do |regex|
              if relative =~ regex
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
