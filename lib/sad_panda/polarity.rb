module SadPanda
  # Polarity calculation logic in here
  class Polarity
    attr_accessor :words, :polarities

    def initialize(text)
      @words = words_in_text(text)
      @polarities = []
    end

    def call
      remove_stopwords

      stem_words

      score_polarities_for(word_frequencies)

      polarities.empty? ? 5.0 : (polarities.sum / polarities.length)
    end

    private

    def happy_emoticon?
      words.include?(':)') ||
        words.include?(':-)') ||
        words.include?(':]') || words.include?(':-]')
    end

    def sad_emoticon?
      words.include?(':(') ||
        words.include?(':-(') ||
        words.include?(':[') || words.include?(':-[')
    end

    def score_emoticon_polarity
      polarities << 5.0 if happy_emoticon? && sad_emoticon?
      polarities << 8.0 if happy_emoticon?
      polarities << 2.0 if sad_emoticon?
    end

    def score_polarities_for(word_frequencies)
      word_frequencies.each do |word, frequency|
        polarity = SadPanda::Polarities[word.to_sym]
        polarities << (polarity * frequency.to_f) if polarity
      end

      score_emoticon_polarity
    end

    # Returns a Hash of frequencies of each uniq word in the text
    def word_frequencies
      word_frequencies = {}
      words.each { |word| word_frequencies[word] = words.count(word) }
      word_frequencies
    end

    # Converts all the words to its stem form
    def stem_words
      stemmer = Lingua::Stemmer.new(language: 'en')
      words.map! { |word| stemmer.stem(word) }
    end

    # Strps the words of stop words
    def remove_stopwords
      @words -= SadPanda::Stopwords
    end

    # Removes all the unwated characters from the text
    def words_in_text(text)
      text.downcase!
      text.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/, '')
      text.gsub!(/(?=\w*h)(?=\w*t)(?=\w*t)(?=\w*p)\w*/, '')
      text.gsub!(/\s\s+/, ' ')
      text.split(' ')
    end
  end
end
