require 'spec_helper'

describe SadPanda::Helpers do
  let(:helpers) { Class.new { extend SadPanda::Helpers } }

  describe '#frequencies_for' do
    it 'returns a hash with the frquency of each word' do
      expect(helpers.frequencies_for(['foo', 'bar', 'quxx', 'foo'])).to eq({'foo' => 2, 'bar' => 1, 'quxx' => 1})
    end
  end

  describe '#stems_for' do
    it 'returns the stems of words' do
      expect(helpers.stems_for(%w[programming amazes])).to eq %w[program amaz]
    end
  end

  describe '#remove_stopwords_in' do
    it 'returns the array without stop words in it' do
      expect(helpers.remove_stopwords_in(%w[this is a cool test])).to eq %w[cool test]
    end
  end

  describe '#words_in' do
    it 'returns an array' do
      expect(helpers.words_in('output array')).to be_a Array
    end

    it 'returns an array of words from the text' do
      expect(helpers.words_in('make this an array')).to eq %w[make this an array]
    end
  end

  describe '#emojies_in' do
    it 'returns sad and happy emojies from the text as an array' do
      expect(helpers.emojies_in('I am :] :). But :( as well.')).to eq [':(', ':)', ':]']
    end
  end

  describe '#sanitize' do
    it 'returns text with only english alphabets' do
      expect(helpers.sanitize('I am :] :). But :( as well.')).to eq 'i am but as well'
    end
  end

  describe '#happy_emoticon?' do
    context 'when words has a happy emoji' do
      it 'returns true' do
        expect(helpers.happy_emoticon?(['foo', ':)'])).to be true
      end
    end

    context 'when words does not have a happy emoji' do
      it 'returns false' do
        expect(helpers.happy_emoticon?(['foo', 'bar'])).to be false
      end
    end
  end

  describe '#sad_emoticon?' do
    context 'when words has a sad emoji' do
      it 'returns true' do
        expect(helpers.sad_emoticon?(['foo', ':('])).to be true
      end
    end

    context 'when words does not have a sad emoji' do
      it 'returns false' do
        expect(helpers.sad_emoticon?(['foo', 'bar'])).to be false
      end
    end
  end
end
