require "spec_helper"

describe Stairs::EnvAdapters::Rbenv do
  subject { described_class.new }

  describe ".present?" do
    before { described_class.should_receive(:`).with("which rbenv-vars") }

    context "when rbenv-vars is installed" do
      before { $?.stub success?: true }

      it "returns true" do
        expect(described_class.present?).to be_true
      end
    end

    context "when rbenv-vars is not installed" do
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
        Regexp.new("^#{name}=(.*)$"),
        "#{name}=#{value}",
        ".rbenv-vars",
      )

      subject.set(name, value)
    end
  end
end