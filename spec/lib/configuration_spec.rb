require 'spec_helper'

describe Stairs::Configuration do
  subject { described_class.new }

  describe 'attributes' do
    it 'allows for configuration of env_adapter' do
      subject.env_adapter = 'test'
      expect(subject.env_adapter).to eq 'test'
    end

    describe 'use_defaults to automatically use default values' do
      it 'defaults to false' do
        expect(subject.use_defaults).to eq false
      end

      it 'allows for configuration' do
        subject.use_defaults = true
        expect(subject.use_defaults).to eq true
      end
    end
  end
end
