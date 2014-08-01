require "spec_helper"

describe Stairs::Steps::SecretKeyBase do
  subject { described_class.new }

  describe "#run" do
    it "generates a securerandom hex and sets to SECRET_KEY_BASE" do
      SecureRandom.stub hex: "imtotallysecurebro"
      subject.should_receive(:env).with("SECRET_KEY_BASE", "imtotallysecurebro")
      subject.run
    end
  end
end
