RSpec.describe Owners::CLI do
  subject { capture(stdin) { command } }

  let(:command) { described_class.start(args) }
  let(:stdin) { StringIO.new }

  def capture(stdin)
    stdin, $stdin = $stdin, stdin
    stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdin = stdin
    $stdout = stdout
  end

  describe "for" do
    let(:args) { ["for", "example/app/controllers/users_controller.rb"] }

    context "without a specified file" do
      it "parses owners correctly" do
        expect(subject).to eq("@org/auth\n@org/blog\n")
      end
    end

    context "with a specified file" do
      before { args << "-f" << "SOMETHING_ELSE" }

      it "overrides the default OWNERS filename" do
        begin
          expect(subject).to eq("")
        ensure
          Owners.file = nil
        end
      end
    end

    context "with debugging" do
      before { args << "-d" }

      it "parses owners correctly" do
        expected = <<-OUTPUT
@org/auth
group
  example/app/controllers/users_controller.rb
  example/app/OWNERS:1 => (?-mix:user)

@org/blog
group
  example/app/controllers/users_controller.rb
  example/OWNERS:2 => (?-mix:.*)

        OUTPUT

        expect(subject).to eq(expected)
      end
    end

    context "with stdin" do
      let(:stdin) { StringIO.new("example/app/controllers/users_controller.rb") }

      context "without paths" do
        let(:args) { ["for"] }

        it "reads paths from stdin" do
          expect(subject).to eq("@org/auth\n@org/blog\n")
        end
      end

      context "with paths" do
        it "does not read paths from stdin" do
          expect(subject).to eq("@org/auth\n@org/blog\n")
        end
      end

      context "after timeout" do
        let(:args) { ["for"] }
        let(:stdin) { double("stdin") }

        it "assumes no files were specified" do
          expect(stdin).to receive(:read) { raise Timeout::Error }
          expect(subject).to eq("")
        end
      end
    end
  end

  describe "for_diff" do
    let(:args) { ["for_diff", "781b3b2", "ba7cd78"] }

    context "without a specified file" do
      it "parses owners correctly" do
        expect(subject).to eq("@org/blog\ndata@example.com\n@whitespace\n")
      end
    end

    context "with a specified file" do
      before { args << "--file" << "SOMETHING_ELSE" }

      it "overrides the default OWNERS filename" do
        begin
          expect(subject).to eq("")
        ensure
          Owners.file = nil
        end
      end
    end
  end

  describe ".missing_for" do
    context "with multiple paths" do
      let(:args) {[
        "missing_for",
        "example/app/controllers/posts_controller.rb",
        "path/without/owner.rb",
      ]}

      it "parses missing files missing owners correctly" do
        expect(subject).to eq("path/without/owner.rb\n")
      end
    end
  end
end
