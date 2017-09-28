require 'spec_helper'

describe SadPanda::Bank do
  describe 'when STOPWORDS is accessed' do
    it 'returns an Array' do
      expect(SadPanda::Bank::STOPWORDS).to be_a Array
    end

    it 'is not empty' do
      expect(SadPanda::Bank::STOPWORDS).to_not be_empty
    end
  end
end
