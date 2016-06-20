require "spec_helper"

RSpec.describe Owners::Owner do
  describe "#paths" do
    subject { described_class.new("test") }

    it "parses paths correctly" do
      expect(subject.paths).to be_empty

      subject.subscriptions["testing"] << nil
      expect(subject.paths).to eq(["testing"])

      subject.subscriptions["again"] << nil
      expect(subject.paths).to eq(["testing", "again"])
    end
  end

  describe "#type" do
    subject { described_class.new(owner).type }

    context "with an alert" do
      let(:owner) { "!alert" }

      it "parses type correctly" do
        expect(subject).to eq(:alert)
      end
    end

    context "with an email" do
      let(:owner) { "test+extra@example.com" }

      it "parses type correctly" do
        expect(subject).to eq(:email)
      end
    end

    context "with a group" do
      let(:owner) { "@example/group-name" }

      it "parses type correctly" do
        expect(subject).to eq(:group)
      end
    end

    context "with a mention" do
      let(:owner) { "@test" }

      it "parses type correctly" do
        expect(subject).to eq(:mention)
      end
    end

    context "with a tag" do
      let(:owner) { "#test" }

      it "parses type correctly" do
        expect(subject).to eq(:tag)
      end
    end

    context "with a path" do
      let(:owner) { "/one/two" }

      it "parses type correctly" do
        expect(subject).to eq(:label)
      end
    end

    context "with anything else" do
      let(:owner) { "anything" }

      it "parses type correctly" do
        expect(subject).to eq(:label)
      end
    end
  end
end
