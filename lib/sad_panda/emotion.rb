module SadPanda
  # Emotion determining logic in here
  class Emotion
    attr_accessor :words, :word_frequencies, :scores

    def initialize(text)
      @words = words_in_text(text)
    end

    def call
      remove_stopwords

      stem_words

      calculate_word_frequencies

      score_words

      ambiguous_score

      scores.key(scores.values.max)
    end

    def method_missing(emotion)
      return scores[emotion] if SadPanda::EmotionBank::Emotions.keys.include? emotion

      raise Exception.new('NoMethodError')
    end

    private

    def ambiguous_score
      scores[:ambiguous] = 1 if scores.empty?
    end

    def score_words
      word_frequencies.each do |word, frequency|
        set_emotions(word, frequency)
      end
    end

    def score_emoji
      emotion = emoji_emotion

      return unless emotion

      if scores[emotion]
        scores[emotion] += 1
      else
        scores[emotion] = 1
      end
    end

    def set_emotions(word, frequency)
      SadPanda::EmotionBank::Emotions.keys.each do |emotion|
        score_emotions(emotion, word, frequency)
      end
    end

    def score_emotions(emotion, term, frequency)
      return unless SadPanda::EmotionBank::Emotions[emotion].include?(term)

      @scores ||= {}
      scores[emotion] ||= 0
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
      # binding.pry
      # text.gsub!(/[^a-z ]/i, '')
      text.downcase!
      text.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/, '')
      text.gsub!(/(?=\w*h)(?=\w*t)(?=\w*t)(?=\w*p)\w*/, '')
      text.gsub!(/\s\s+/,' ')
      text.split(' ')
    end
  end
end
