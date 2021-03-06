module Owners
  class CLI < Thor
    include Timeout

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
      run(:for, files)
    end

    desc "for_diff REF [BASE_REF]", "List owners for a set of git changes"
    def for_diff(ref, base_ref = "master")
      Owners.file = options[:file] if options[:file]
      Owners.for_diff(ref, base_ref).each do |owner|
        output(owner)
      end
    end

    desc "missing_for [FILES...]", "List files that don't have owners"
    def missing_for(*files)
      run(:missing_for, files)
    end

    no_commands do
      def output(owner)
        say owner

        if options[:debug]
          last_sub = nil

          owner.subscriptions.each do |path, subscriptions|
            subscriptions.each do |sub|
              if last_sub != sub
                say if last_sub
                say "  #{sub}", :blue
              end

              say "    #{path}", :red unless path == sub.source
              last_sub = sub
            end
          end

          say
        end
      end

      def run(method, files)
        files = stdin_files unless files.any?

        Owners.file = options[:file] if options[:file]

        Owners.send(method, *files).each do |owner|
          output(owner)
        end
      end

      def stdin_files
        timeout(1) { $stdin.read.split("\n") }
      rescue Timeout::Error
        []
      end
    end
  end
end
