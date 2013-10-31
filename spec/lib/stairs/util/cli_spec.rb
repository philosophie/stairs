require "spec_helper"

describe Stairs::Util::CLI do
  subject { described_class }

  describe ".get" do
    it "outputs the prompt to screen" do
      output = follow_prompts("test") { subject.get("itefeffe") }
      expect(output).to include "itefeffe"
    end

    it "collects and returns trimmed input" do
      follow_prompts "test" do
        expect(subject.get("it")).to eq "test"
      end
    end

    it "returns nil for empty input" do
      follow_prompts "" do
        expect(subject.get("it")).to eq nil
      end
    end
  end

  describe ".collect" do
    it "returns the user provided input" do
      follow_prompts "test" do
        expect(subject.collect("itefeffe")).to eq "test"
      end
    end

    context "required" do
      it "repeatedly prompts until a non-empty value is received" do
        follow_prompts "", "", "", "finally" do
          expect(subject.collect("a value")).to eq "finally"
        end
      end
    end

    context "not required" do
      it "returns nil for empty input" do
        follow_prompts "" do
          expect(subject.collect("gimme", required: false)).to eq nil
        end
      end
    end

    context "with custom validation block" do
      it "repeatedly prompts until a valid value is received" do
        follow_prompts "", "", "wrong", "right" do
          response = subject.collect("a value") { |v, i| v == "right" }
          expect(response).to eq "right"
        end
      end
    end
  end
end