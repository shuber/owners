module Owners
  class CLI < Thor
    desc "for [FILES...]", "List owners for a set of files"
    method_option :file, desc: "The name of the OWNERS file"
    def for(*files)
      Owners.file = options[:file] if options[:file]
      Owners.for(*files).each do |owner|
        puts owner
      end
    end

    desc "for_diff REF [BASE_REF]", "List owners for a set of git changes"
    method_option :file, desc: "The name of the OWNERS file"
    def for_diff(ref, base_ref = "master")
      Owners.file = options[:file] if options[:file]
      Owners.for_diff(ref, base_ref).each do |owner|
        puts owner
      end
    end
  end
end
