require 'sad_panda/helpers'

module SadPanda
  # Polarity calculation logic in here
  class Polarity
    include Helpers

    attr_accessor :words, :polarities

    def initialize(text)
      @words = words_in(text)
      @polarities = []
    end

    # Main method that initiates calculating polarity
    def call
      words = stems_for(remove_stopwords_in(@words))

      score_polarities_for(frequencies_for(words))

      polarities.empty? ? 5.0 : (polarities.sum / polarities.length)
    end

    private

    # Checks if words has happy or sad emoji and adds polarity for it
    def score_emoticon_polarity
      polarities << 5.0 if happy_emoticon?(words) && sad_emoticon?(words)
      polarities << 8.0 if happy_emoticon?(words)
      polarities << 2.0 if sad_emoticon?(words)
    end

    # Appends polarities of words to array polarities
    def score_polarities_for(word_frequencies)
      word_frequencies.each do |word, frequency|
        polarity = SadPanda::Bank::POLARITIES[word.to_sym]
        polarities << (polarity * frequency.to_f) if polarity
      end

      score_emoticon_polarity
    end
  end
end
