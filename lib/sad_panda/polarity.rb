require 'sad_panda/helpers'

module SadPanda
  # Polarity calculation logic in here
  class Polarity
    include Helpers

    attr_accessor :words, :polarities

    def initialize(text)
      @words = words_in_text(text)
      @polarities = []
    end

    # Main method that initiates calculating polarity
    def call
      words = stem_words(remove_stopwords(@words))

      score_polarities_for(get_frequencies_for(words))

      polarities.empty? ? 5.0 : (polarities.sum / polarities.length)
    end

    private

    # Checks if words has a happy emoji
    def happy_emoticon?
      words.include?(':)') ||
        words.include?(':-)') ||
        words.include?(':]') || words.include?(':-]')
    end

    # Checks if words has a sad emoji
    def sad_emoticon?
      words.include?(':(') ||
        words.include?(':-(') ||
        words.include?(':[') || words.include?(':-[')
    end

    # Checks if words has happy or sad emoji and adds polarity for it
    def score_emoticon_polarity
      polarities << 5.0 if happy_emoticon? && sad_emoticon?
      polarities << 8.0 if happy_emoticon?
      polarities << 2.0 if sad_emoticon?
    end

    # Appends polarities of words to array polarities
    def score_polarities_for(word_frequencies)
      word_frequencies.each do |word, frequency|
        polarity = SadPanda::Polarities[word.to_sym]
        polarities << (polarity * frequency.to_f) if polarity
      end

      score_emoticon_polarity
    end
  end
end
