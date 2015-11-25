RSpec.describe Owners::CLI do
  describe "for" do
    subject { capture { command } }
    let(:command) { described_class.start(args) }
    let(:args) { ["for", "example/app/controllers/users_controller.rb"] }

    def capture
      stdout = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = stdout
    end

    context "without a specified file" do
      it "parses owners correctly" do
        expect(subject).to eq("@org/auth\n@org/blog\n")
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
end
