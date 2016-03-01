module Owners
  class CLI < Thor
    class_option :debug,
      aliases: %w(-d),
      desc: "Output additional subscription debugging info",
      type: :boolean

    class_option :file,
      aliases: %w(-f),
      desc: "The name of the OWNERS file",
      type: :string

    desc "for [FILES...]", "List owners for a set of files"
    def for(*files)
      Owners.file = options[:file] if options[:file]
      Owners.for(*files).each do |owner|
        output(owner)
      end
    end

    desc "for_diff REF [BASE_REF]", "List owners for a set of git changes"
    def for_diff(ref, base_ref = "master")
      Owners.file = options[:file] if options[:file]
      Owners.for_diff(ref, base_ref).each do |owner|
        output(owner)
      end
    end

    no_commands do
      def output(owner)
        say owner

        if options[:debug]
          say owner.type, :yellow

          owner.subscriptions.each do |path, subscriptions|
            subscriptions.each do |sub|
              say "  #{path}", :red
              say "  #{sub.file}:#{sub.line} => #{sub.filter}", :blue
            end

            say
          end
        end
      end
    end
  end
end
