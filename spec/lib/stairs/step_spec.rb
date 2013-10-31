require "spec_helper"

describe Stairs::Step do
  let(:anon_step) { Class.new(described_class) }
  subject { anon_step.new }

  describe "metadata" do
    describe "step_title" do
      it "can be set on the class using title class DSL" do
        anon_step.title "Class Step Name"
        expect(subject.step_title).to eq "Class Step Name"
      end

      it "can be set on the instance" do
        subject.step_title = "Instance Step Name"
        expect(subject.step_title).to eq "Instance Step Name"
      end

      it "prefers the value set on instance" do
        anon_step.title "Class Step Name"
        subject.step_title = "Instance Step Name"
        expect(subject.step_title).to eq "Instance Step Name"
      end
    end

    describe "step_description" do
      it "can be set on the class using description class DSL" do
        anon_step.description "Class Step Description"
        expect(subject.step_description).to eq "Class Step Description"
      end

      it "can be set on the instance" do
        subject.step_description = "Instance Step Description"
        expect(subject.step_description).to eq "Instance Step Description"
      end

      it "prefers the value set on instance" do
        anon_step.title "Class Step Description"
        subject.step_description = "Instance Step Description"
        expect(subject.step_description).to eq "Instance Step Description"
      end
    end
  end

  describe "#run!" do
    before { subject.stub run: true }
    before { anon_step.title "Step Name" }

    it "outputs lead-in message" do
      output = capture_stdout { subject.run! }
      expect(output).to include "== Running Step Name"
    end

    it "calls #run where the implementation lives" do
      subject.should_receive(:run)
      subject.run!
    end

    it "outputs completed message" do
      output = capture_stdout { subject.run! }
      expect(output).to include "== Completed Step Name"
    end
  end

  describe "#provide" do
    it "prompts the user to provide input" do
      output = follow_prompts("here") { subject.provide "Gimme" }
      expect(output).to include "Gimme: "
    end

    it "returns the input" do
      follow_prompts("here") do
        expect(subject.provide("Gimme")).to eq "here"
      end
    end

    it "requires user input" do
      follow_prompts "", "", "", "finally" do
        expect(subject.provide("Gimme")).to eq "finally"
      end
    end

    context "with a default" do
      def call_method
        subject.provide "Gimme", default: "adefault"
      end

      it "does not require input" do
        output = follow_prompts("here") { call_method }
      end

      context "and required" do
        it "does not require input" do
          follow_prompts "" do
            expect(subject.provide("Gimme", required: true, default: "adefault")).to eq "adefault"
          end
        end
      end

      context "with no input" do
        it "returns the default" do
          follow_prompts("") do
            expect(call_method).to eq "adefault"
          end
        end
      end

      context "with input" do
        it "returns the input" do
          follow_prompts("here") do
            expect(call_method).to eq "here"
          end
        end
      end
    end

    context "optional" do
      it "does not require input" do
        follow_prompts "" do
          expect(subject.provide("Gimme", required: false)).to eq nil
        end
      end
    end
  end

  describe "#choice" do
    it "prompts the user to answer the question" do
      output = follow_prompts("Y") { subject.choice("Should I?") }
      expect(output).to include "Should I?"
    end

    it "defaults to a Y/N question" do
      output = follow_prompts("Y") { subject.choice("Should I?") }
      expect(output).to include "(Y/N)"
    end

    it "returns true for Y" do
      follow_prompts("Y") { expect(subject.choice("Should I?")).to be_true }
    end

    it "returns true for Y" do
      follow_prompts("N") { expect(subject.choice("Should I?")).to be_false }
    end

    context "with available choices provided" do
      it "displays those choices" do
        output = follow_prompts("Nick") { subject.choice("What's your name?", ["Nick", "Brendan"]) }
        expect(output).to include "(Nick/Brendan)"
      end

      it "returns the user's choice" do
        follow_prompts("Nick") do
          expect(subject.choice("What's your name?", ["Nick", "Brendan"])).to eq "Nick"
        end
      end

      it "prompts repeatedly until it receives input in available choices" do
        follow_prompts("Sally", "Frank", "Nick") do
          expect(subject.choice("What's your name?", ["Nick", "Brendan"])).to eq "Nick"
        end
      end
    end

    context "with a block" do
      it "calls the block with the user's choice" do
        follow_prompts("Nick") do
          expect do |block|
            subject.choice("What's your name?", ["Nick", "Brendan"], &block)
          end.to yield_with_args("Nick")
        end
      end
    end
  end

  describe "#bundle" do
    before { subject.stub system: true }

    it "outputs lead-in message" do
      output = capture_stdout { subject.bundle }
      expect(output).to include "== Running bundle"
    end

    it "runs bundle" do
      subject.should_receive(:system).with("bundle")
      subject.bundle
    end

    it "outputs completed message" do
      output = capture_stdout { subject.bundle }
      expect(output).to include "== Completed bundle"
    end
  end

  describe "#rake" do
    before { subject.stub system: true }

    it "outputs lead-in message" do
      output = capture_stdout { subject.rake "the_task" }
      expect(output).to include "== Running the_task"
    end

    it "runs the rake task" do
      subject.should_receive(:system).with("rake the_task")
      subject.rake "the_task"
    end

    it "outputs completed message" do
      output = capture_stdout { subject.rake "the_task" }
      expect(output).to include "== Completed the_task"
    end
  end

  describe "#env" do
    let(:adapter) { double("adapter", set: true) }
    before { Stairs.configuration.env_adapter = adapter }

    it "delegates to the adapter" do
      adapter.should_receive(:set).with("NAME", "value")
      subject.env "NAME", "value"
    end

    it "writes to ENV simultaneously so Rubyland can access without a reload" do
      ENV.should_receive(:[]=).with("NAME", "value")
      subject.env "NAME", "value"
    end
  end

  describe "#write" do
    it "delegates to the well tested FileMutation util" do
      Stairs::Util::FileMutation.should_receive(:write).with("something", "file.txt")
      subject.write("something", "file.txt")
    end
  end

  describe "#write_line" do
    it "delegates to the well tested FileMutation util" do
      Stairs::Util::FileMutation.should_receive(:write_line).with("something", "file.txt")
      subject.write_line("something", "file.txt")
    end
  end

  describe "#finish" do
    it "outputs lead-in message" do
      output = capture_stdout { subject.finish "Message" }
      expect(output).to include "== All done!"
    end

    it "outputs supplied message" do
      output = capture_stdout { subject.finish "My message" }
      expect(output).to include "My message"
    end
  end

  describe "#stairs_info" do
    it "outputs the message" do
      output = capture_stdout { subject.stairs_info "Ohai" }
      expect(output).to include "Ohai"
    end
  end

  describe "#setup" do
    context "with an invalid step_name" do
      it "raises when step_name cannot be resolved in Stairs::Steps" do
        expect { subject.setup :blahblahbefkj }.to raise_error
      end
    end

    context "with a valid step_name" do
      let!(:mock_step_class) { Stairs::Steps::MockStep = Class.new(Stairs::Step) }

      it "instantiates and runs the step" do
        mock_step_class.any_instance.should_receive(:run!)
        subject.setup :mock_step
      end
    end

    context "with a block" do
      def call_method
        subject.setup(:custom_step) { puts "I'm running in #{self.class}" }
      end

      it "sets the new step's title to a titleized version of step_name" do
        output = capture_stdout { call_method }
        expect(output).to include "Custom Step"
      end

      it "runs the block in the context of the new step" do
        output = capture_stdout { call_method }
        expect(output).to include "I'm running in Stairs::Step"
      end
    end
  end
end