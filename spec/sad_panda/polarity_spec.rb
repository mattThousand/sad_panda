require 'spec_helper'

describe SadPanda::Polarity do
  describe 'initialization' do
    let(:object) { SadPanda::Polarity.new('Initialize this text in sad panda') }

    it 'initializes polarities as an empty Array' do
      expect(object.polarities).to eq []
    end

    it 'initializes words in an Array' do
      expect(object.words).to eq %w[initialize this text in sad panda]
    end
  end

  describe '#call' do
    context 'when input contains no words with polarities' do
      let(:object) { SadPanda::Polarity.new(' ') }

      it 'returns 5.0' do
        expect(object.call).to eq 5.0
      end

      it 'adds no polarities of words to polarities Array' do
        object.call

        expect(object.polarities).to eq []
      end
    end

    context 'when input contains a word with polarity' do
      let(:object) { SadPanda::Polarity.new('I love cactuses!') }

      it 'returns 10.0' do
        expect(object.call).to eq 10.0
      end

      it 'adds polarities of words to polarities Array' do
        object.call

        expect(object.polarities).to eq [10.0]
      end
    end
  end

  describe '#happy_emoticon?' do
    context 'when words has a happy emoji' do
      let(:object) { SadPanda::Polarity.new('I love cactuses. :)') }

      it 'returns true' do
        expect(object.send(:happy_emoticon?)).to be true
      end
    end

    context 'when words does not have a happy emoji' do
      let(:object) { SadPanda::Polarity.new('I love cactuses!') }

      it 'returns true' do
        expect(object.send(:happy_emoticon?)).to be false
      end
    end
  end

  describe '#sad_emoticon?' do
    context 'when words has a sad emoji' do
      let(:object) { SadPanda::Polarity.new('I dont love cactuses. :(') }

      it 'returns true' do
        expect(object.send(:sad_emoticon?)).to be true
      end
    end

    context 'when words does not not have a sad emoji' do
      let(:object) { SadPanda::Polarity.new('I dont love cactuses') }

      it 'returns true' do
        expect(object.send(:sad_emoticon?)).to be false
      end
    end
  end

  describe '#score_emoticon_polarity' do
    context 'when words has a sad emoji' do
      let(:object) { SadPanda::Polarity.new('I am :(') }

      it 'adds 2.0 to polarities' do
        object.send(:score_emoticon_polarity)

        expect(object.polarities.include?(2.0)).to be true
      end
    end

    context 'when words has a happy emoji' do
      let(:object) { SadPanda::Polarity.new('I am :)') }

      it 'adds 8.0 to polarities' do
        object.send(:score_emoticon_polarity)

        expect(object.polarities.include?(8.0)).to be true
      end
    end

    context 'when words has sad & happy emoji' do
      let(:object) { SadPanda::Polarity.new('I am :) and :(') }

      it 'adds 5.0 to polarities' do
        object.send(:score_emoticon_polarity)

        expect(object.polarities.include?(5.0)).to be true
      end
    end
  end

  describe '#score_polarities_for' do
    let(:object) { SadPanda::Polarity.new('') }

    it 'appends the right polarities of words to polarities' do
      object.send(:score_polarities_for, { 'abandoned' => 1, 'educated' => 1 })

      expect(object.polarities).to eq [2.5, 7.5]
    end
  end
end
