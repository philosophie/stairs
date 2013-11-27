require "spec_helper"

describe Stairs::Runner do
  describe "#run!" do
    let(:script_double) { double("script", run!: true) }

    before do
      # Stub things as to not block IO
      Stairs::InteractiveConfiguration.any_instance.stub :run!
      Stairs::Script.any_instance.stub :run!
      Stairs::Script.stub(:new).and_return(script_double)
    end

    it "runs the interactive configuration" do
      Stairs::InteractiveConfiguration.any_instance.should_receive(:run!)
      subject.run!
    end

    it "runs the setup.rb script" do
      Stairs::Script.should_receive(:new).with("setup.rb").and_return(script_double)
      script_double.should_receive(:run!)

      subject.run!
    end
  end
end
