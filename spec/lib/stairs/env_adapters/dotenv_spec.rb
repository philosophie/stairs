require 'spec_helper'

describe Stairs::EnvAdapters::Dotenv do
  subject { described_class.new }

  describe '.present?' do
    context 'when rvm is installed' do
      before { stub_const 'Dotenv', double('dotenv') }

      it 'returns true' do
        expect(described_class.present?).to be_true
      end
    end

    context 'when rvm is not installed' do
      before { Object.send(:remove_const, :Dotenv) if defined? ::Dotenv }

      it 'returns true' do
        expect(described_class.present?).to be_false
      end
    end
  end

  describe '#set' do
    it 'delegates to the well tested FileMutation util' do
      name = 'VAR_NAME'
      value = 'the_value'

      Stairs::Util::FileMutation.should_receive(:replace_or_append).with(
        Regexp.new("^#{name}=(.*)$"),
        "#{name}=#{value}",
        '.env'
      )

      subject.set(name, value)
    end
  end

  describe '#unset' do
    it 'delegates to the well tested FileMutation util' do
      Stairs::Util::FileMutation.should_receive(:remove).with(
        Regexp.new("^SOMETHING=(.*)\n"),
        '.env'
      )
      subject.unset 'SOMETHING'
    end
  end
end
