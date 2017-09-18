module SadPanda
  # Emotion determining logic in here
  class Emotion
    attr_accessor :words, :word_frequencies, :scores

    def initialize(text)
      @words = words_in_text(text)
      @scores = { anger: 0, disgust: 0, joy: 0,
                  surprise: 0, fear: 0, sadness: 0,
                  ambiguous: 0 }
    end

    def call
      remove_stopwords

      stem_words

      calculate_word_frequencies

      score_words

      scores.key(scores.values.max)
    end

    def method_missing(emotion)
      return scores[emotion] || 0 if scores.keys.include? emotion

      raise NoMethodError, 'This method is not defined'
    end

    private

    def ambiguous_score
      unq_scores = scores.values.uniq
      scores[:ambiguous] = 1 if unq_scores.length == 1 && unq_scores.first.zero?
    end

    def score_words
      word_frequencies.each do |word, frequency|
        set_emotions(word, frequency)
      end

      ambiguous_score
    end

    def score_emoji
      emotion = emoji_emotion

      return unless emotion

      scores[emotion] += 1
    end

    def set_emotions(word, frequency)
      SadPanda::EmotionBank::Emotions.keys.each do |emotion|
        score_emotions(emotion, word, frequency)
      end
    end

    def score_emotions(emotion, term, frequency)
      return unless SadPanda::EmotionBank::Emotions[emotion].include?(term)

      scores[emotion] += frequency
    end

    def stem_words
      stemmer = Lingua::Stemmer.new(language: 'en')
      words.map! { |word| stemmer.stem(word) }
    end

    def calculate_word_frequencies
      @word_frequencies = {}
      words.each { |word| word_frequencies[word] = words.count(word) }
    end

    def remove_stopwords
      @words -= SadPanda::Stopwords
    end

    def words_in_text(text)
      text.downcase!
      text.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/, '')
      text.gsub!(/(?=\w*h)(?=\w*t)(?=\w*t)(?=\w*p)\w*/, '')
      text.gsub!(/\s\s+/,' ')
      text.split(' ')
    end
  end
end
