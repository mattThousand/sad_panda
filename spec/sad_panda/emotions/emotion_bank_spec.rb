require 'spec_helper'

describe SadPanda::EmotionBank do
  let(:emotions) { SadPanda::EmotionBank::Emotions }

  describe 'EmotionBank module' do
    it 'returns a hash' do
      expect(emotions).to be_a Hash
    end

    it 'is not empty' do
      expect(emotions).to_not be_empty
    end

    it 'has all the emotions as keys' do
      expect(emotions.keys).to eq %i[anger disgust joy surprise fear sadness]
    end

    context 'constants' do
      it 'returns an Array for SADNESS' do
        expect(SadPanda::EmotionBank::SADNESS).to be_a Array
      end

      it 'returns an Array for JOY' do
        expect(SadPanda::EmotionBank::JOY).to be_a Array
      end

      it 'returns an Array for ANGER' do
        expect(SadPanda::EmotionBank::ANGER).to be_a Array
      end

      it 'returns an Array for DISGUST' do
        expect(SadPanda::EmotionBank::DISGUST).to be_a Array
      end

      it 'returns an Array for FEAR' do
        expect(SadPanda::EmotionBank::FEAR).to be_a Array
      end

      it 'returns an Array for SURPRISE' do
        expect(SadPanda::EmotionBank::SURPRISE).to be_a Array
      end
    end
  end
end