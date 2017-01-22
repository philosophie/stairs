require 'spec_helper'

describe Stairs::EnvAdapters::Rbenv do
  subject { described_class.new }

  describe '.present?' do
    before { expect(described_class).to receive(:`).with('which rbenv-vars') }

    context 'when rbenv-vars is installed' do
      before { allow($CHILD_STATUS).to receive(:success?).and_return(true) }

      it 'returns true' do
        expect(described_class.present?).to eq true
      end
    end

    context 'when rbenv-vars is not installed' do
      before { allow($CHILD_STATUS).to receive(:success?).and_return(false) }

      it 'returns true' do
        expect(described_class.present?).to eq false
      end
    end
  end

  describe '#set' do
    it 'delegates to the well tested FileMutation util' do
      name = 'VAR_NAME'
      value = 'the_value'

      expect(Stairs::Util::FileMutation).to receive(:replace_or_append).with(
        Regexp.new("^#{name}=(.*)$"),
        "#{name}=#{value}",
        '.rbenv-vars'
      )

      subject.set(name, value)
    end
  end

  describe '#unset' do
    it 'delegates to the well tested FileMutation util' do
      expect(Stairs::Util::FileMutation).to receive(:remove).with(
        Regexp.new("^SOMETHING=(.*)\n"),
        '.rbenv-vars'
      )
      subject.unset 'SOMETHING'
    end
  end
end
