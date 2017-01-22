require 'spec_helper'

describe Stairs::Runner do
  let(:groups) { nil }
  let(:subject) { described_class.new(groups) }

  describe '#run!' do
    let(:script_double) { double('script', run!: true) }

    before do
      # Stub things as to not block IO
      allow_any_instance_of(Stairs::InteractiveConfiguration).to receive(:run!)
      allow_any_instance_of(Stairs::Script).to receive(:run!)
      allow(Stairs::Script).to receive(:new).and_return(script_double)
    end

    it 'runs the interactive configuration' do
      expect_any_instance_of(Stairs::InteractiveConfiguration)
        .to receive(:run!)

      subject.run!
    end

    it 'runs all groups in the setup.rb script' do
      expect(Stairs::Script)
        .to receive(:new).with('setup.rb', groups).and_return(script_double)

      expect(script_double).to receive(:run!)

      subject.run!
    end

    context 'with groups provided' do
      let(:groups) { [:reset] }

      it 'passes the specified groups to the script' do
        expect(Stairs::Script).to receive(:new).with('setup.rb', groups)
        subject.run!
      end
    end
  end
end
