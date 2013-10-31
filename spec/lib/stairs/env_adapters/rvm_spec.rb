require "spec_helper"

describe Stairs::EnvAdapters::RVM do
  subject { described_class.new }

  describe ".present?" do
    before { described_class.should_receive(:`).with("which rvm") }

    context "when rvm is installed" do
      before { $?.stub success?: true }

      it "returns true" do
        expect(described_class.present?).to be_true
      end
    end

    context "when rvm is not installed" do
      before { $?.stub success?: false }

      it "returns true" do
        expect(described_class.present?).to be_false
      end
    end
  end

  describe "#set" do
    it "delegates to the well tested FileMutation util" do
      name = "VAR_NAME"
      value = "the_value"

      Stairs::Util::FileMutation.should_receive(:replace_or_append).with(
        Regexp.new("^export #{name}=(.*)$"),
        "export #{name}=#{value}",
        ".rvmrc",
      )

      subject.set(name, value)
    end
  end
end