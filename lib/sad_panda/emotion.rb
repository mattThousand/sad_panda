module SadPanda
  # Emotion determining logic in here
  class Emotion
    attr_accessor :words, :scores

    def initialize(text)
      @words = words_in_text(text)
      @scores = { anger: 0, disgust: 0, joy: 0,
                  surprise: 0, fear: 0, sadness: 0,
                  ambiguous: 0 }
    end

    # Main method that initiates scoring emotions
    def call
      remove_stopwords

      stem_words

      score_words(word_frequencies)

      scores.key(scores.values.max)
    end

    # MethodMissing to implement metods that
    # are the names of each emotion that will returen
    # the score of that specific emotion for the text
    def method_missing(emotion)
      return scores[emotion] || 0 if scores.keys.include? emotion

      raise NoMethodError, 'This method is not defined'
    end

    private

    # Last part of the scoring process
    # If all scores are empty ambiguous is scored as 1
    def ambiguous_score
      unq_scores = scores.values.uniq
      scores[:ambiguous] = 1 if unq_scores.length == 1 && unq_scores.first.zero?
    end

    # Increments the score of an emotion if the word exist
    # in that emotion bank
    def score_emotions(emotion, term, frequency)
      return unless SadPanda::EmotionBank::Emotions[emotion].include?(term)

      scores[emotion] += frequency
    end

    # Iterates all emotions for word in text
    def set_emotions(word, frequency)
      SadPanda::EmotionBank::Emotions.keys.each do |emotion|
        score_emotions(emotion, word, frequency)
      end
    end

    # Logic to score all unique words in the text
    def score_words(word_frequencies)
      word_frequencies.each do |word, frequency|
        set_emotions(word, frequency)
      end

      ambiguous_score
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
