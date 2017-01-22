require 'spec_helper'

describe Stairs::Script do
  let(:filename) { 'setup.rb' }
  let(:groups) { [:reset] }
  subject { described_class.new(filename, groups) }

  context 'with a script present' do
    before do
      File.open(filename, 'w') do |file|
        file.write('self.class')
      end
    end

    after { File.delete(filename) }

    describe 'initialize' do
      it 'receives groups' do
        expect { described_class.new(filename, groups) }.not_to raise_error
      end
    end

    describe '#run!' do
      it 'outputs running message' do
        output = capture_stdout { subject.run! }
        expect(output).to include '= Running script setup.rb'
      end

      it 'passes groups to the new instance of Step' do
        expect(Stairs::Step).to receive(:new).with(groups)
        subject.run!
      end

      it 'evaluates the script in the context of an instance of Step' do
        # because our test setup.rb only contains `self.class` we can check
        # this way:
        expect(subject.run!).to eq Stairs::Step
      end
    end
  end
end
