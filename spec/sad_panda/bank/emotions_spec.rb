require 'spec_helper'

describe SadPanda::Bank do
  let(:emotions) { SadPanda::Bank::EMOTIONS }

  describe 'EMOTIONS constant' do
    it 'returns a hash' do
      expect(emotions).to be_a Hash
    end

    it 'is not empty' do
      expect(emotions).to_not be_empty
    end

    it 'has all the emotions as keys' do
      expect(emotions.keys).to eq [:anger, :disgust, :joy, :surprise, :fear, :sadness]
    end

    context 'constants' do
      it 'returns an Array for SADNESS' do
        expect(SadPanda::Bank::EMOTIONS[:anger]).to be_a Array
      end

      it 'returns an Array for JOY' do
        expect(SadPanda::Bank::EMOTIONS[:joy]).to be_a Array
      end

      it 'returns an Array for ANGER' do
        expect(SadPanda::Bank::EMOTIONS[:anger]).to be_a Array
      end

      it 'returns an Array for DISGUST' do
        expect(SadPanda::Bank::EMOTIONS[:disgust]).to be_a Array
      end

      it 'returns an Array for FEAR' do
        expect(SadPanda::Bank::EMOTIONS[:fear]).to be_a Array
      end

      it 'returns an Array for SURPRISE' do
        expect(SadPanda::Bank::EMOTIONS[:surprise]).to be_a Array
      end
    end
  end
end