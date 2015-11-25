module Owners
  class CLI < Thor
    desc "for [FILES...]", "List owners for a set of files"

    method_option :file,
      lazy_default: -> { Owners.file },
      desc: "The name of the OWNERS file"

    def for(*files)
      Owners.file = options[:file]
      Owners.for(*files).each do |owner|
        puts owner
      end
    end
  end
end
