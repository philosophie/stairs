require "spec_helper"

describe Stairs::Configuration do
  subject { described_class.new }

  describe "attributes" do
    it "allows for configuration of env_adapter" do
      subject.env_adapter = "test"
      expect(subject.env_adapter).to eq "test"
    end
  end
end