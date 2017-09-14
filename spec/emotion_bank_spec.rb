require 'spec_helper'

describe SadPanda::EmotionBank do
  let(:output) { SadPanda::EmotionBank::Emotions }

  describe 'EmotionBank module is called' do
    it 'returns a hash' do
      expect(output).to be_a Hash
    end

    it 'is not empty' do
      expect(output).to_not be_empty
    end
  end
end
