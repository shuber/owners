RSpec.describe Owners::CLI do
  describe "for" do
    subject { described_class.new }

    let(:command) { "bin/owners for #{path}" }
    let(:path) { "example/app/controllers/users_controller.rb" }

    it "parses owners correctly" do
      expect(`#{command}`).to eq("@org/auth\n@org/blog\n")
    end

    it "allows the OWNERS file to be changed" do
      expect(`#{command} --file SOME_OTHER_FILE`).to eq("")
    end
  end
end
