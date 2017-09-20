require 'spec_helper'

describe SadPanda::Polarities do
  describe 'when TermPolarities module is called' do
    it 'returns a hash' do
      expect(SadPanda::Polarities).to be_a Hash
    end

    it 'is non empty' do
      expect(SadPanda::Polarities).to_not be_empty
    end
  end
end
