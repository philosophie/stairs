require "spec_helper"

describe Stairs::Steps::SecretToken do
  subject { described_class.new }

  describe "#run" do
    it "generates a securerandom hex and sets to SECRET_TOKEN" do
      SecureRandom.stub hex: "imtotallysecurebro"
      subject.should_receive(:env).with("SECRET_TOKEN", "imtotallysecurebro")
      subject.run
    end
  end
end