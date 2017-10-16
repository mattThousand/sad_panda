require 'spec_helper'

describe SadPanda::Bank do
  describe 'when POLARITIES is accessed' do
    it 'returns a hash' do
      expect(SadPanda::Bank::POLARITIES).to be_a Hash
    end

    it 'is not empty' do
      expect(SadPanda::Bank::POLARITIES).to_not be_empty
    end
  end
end
