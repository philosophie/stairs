require "spec_helper"

describe Stairs::Runner do
  let(:groups) { nil }
  let(:subject) { described_class.new(groups) }

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

    it "runs all groups in the setup.rb script" do
      Stairs::Script.should_receive(:new).with("setup.rb", groups).and_return(script_double)
      script_double.should_receive(:run!)

      subject.run!
    end

    context "with groups provided" do
      let(:groups) { [:reset] }

      it "passes the specified groups to the script" do
        Stairs::Script.should_receive(:new).with("setup.rb", groups)
        subject.run!
      end
    end
  end
end
