RSpec.describe Owners do
  describe ".for" do
    subject { described_class.for(*paths) }

    context "with one path" do
      let(:paths) { ["example/app/controllers/users_controller.rb"] }

      it "parses owners correctly" do
        expect(subject).to eq(["@org/auth", "@org/blog"])
      end
    end

    context "with multiple paths" do
      let(:paths) {[
        "example/app/controllers/posts_controller.rb",
        "example/app/models/user.rb",
      ]}

      it "parses owners correctly" do
        expect(subject).to eq(["@org/auth", "@org/blog", "data@example.com"])
      end
    end

    context "with no paths" do
      let(:paths) { [] }

      it "parses owners correctly" do
        expect(subject).to eq([])
      end
    end

    context "with no matches" do
      let(:paths) { ["some-path-without-owners"] }

      it "parses owners correctly" do
        expect(subject).to be_empty
      end
    end

    context "with a regex matcher" do
      let(:paths) { ["example/app/models/blog.rb"] }

      it "parses owners correctly" do
        expect(subject).to eq(["@blogger", "@org/blog", "data@example.com"])
      end
    end

    context "with a rule containing whitespace" do
      let(:paths) { ["example/app/models/post.rb"] }

      it "parses owners correctly" do
        expect(subject).to eq(["@org/blog", "@whitespace", "data@example.com"])
      end
    end

    context "with multiple owners" do
      let(:paths) { ["example/app/models/comment.rb"] }

      it "parses owners correctly" do
        expect(subject).to eq(["@duplicate", "@org/blog", "@owner", "data@example.com"])
      end
    end

    context "with multiple comma separated owners" do
      let(:paths) { ["example/db/schema.rb"] }

      it "parses owners correctly" do
        expect(subject).to eq(["@multiple", "@org/blog", "@owners"])
      end
    end

    context "with empty comma separated owners" do
      let(:paths) { ["example/db/schema.rb"] }

      it "parses owners correctly" do
        expect(subject).to eq(["@multiple", "@org/blog", "@owners"])
      end
    end

    context "with comments" do
      let(:paths) { ["example/comment"] }

      it "parses owners correctly" do
        expect(subject).to eq(["@org/blog"])
      end
    end
  end

  describe ".for_diff" do
    subject { described_class.for_diff(ref, base_ref) }

    context "when comparing one commit" do
      let(:ref) { "781b3b2" }
      let(:base_ref) { "6f4f89a" }

      it "parses owners correctly" do
        expect(subject).to eq(["@org/blog"])
      end
    end

    context "when comparing multiple commits" do
      let(:ref) { "781b3b2" }
      let(:base_ref) { "ba7cd78" }

      it "parses owners correctly" do
        expect(subject).to eq(["@org/blog", "@whitespace", "data@example.com"])
      end
    end
  end
end
