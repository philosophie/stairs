require 'spec_helper'

describe Stairs::EnvAdapters do
  subject { described_class }
  let(:present_adapter) { double('adapter', present?: true) }
  let(:other_adapter) { double('adapter', present?: false) }
  let(:another_adapter) { double('adapter', present?: false) }

  before do
    stub_const 'Stairs::EnvAdapters::ADAPTERS', one: other_adapter,
                                                two: present_adapter,
                                                three: another_adapter
  end

  describe '.recommended_adapter' do
    it 'returns the first adapter to be `present?`' do
      expect(described_class.recommended_adapter).to eq present_adapter
    end
  end

  describe '.name_for_adapter_class' do
    it 'returns the name' do
      expect(described_class.name_for_adapter_class(present_adapter)).to eq :two
    end
  end
end
