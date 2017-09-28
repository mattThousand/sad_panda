require 'sad_panda/helpers'

module SadPanda
  # Emotion determining logic in here
  class Emotion
    include Helpers

    attr_accessor :words, :scores

    def initialize(text)
      @words = words_in(text)
      @scores = { anger: 0, disgust: 0, joy: 0,
                  surprise: 0, fear: 0, sadness: 0,
                  ambiguous: 0 }
    end

    # Main method that initiates scoring emotions
    def call
      words = stems_for(remove_stopwords_in(@words))
      score_words(frequencies_for(words))

      scores.key(scores.values.max)
    end

    # MethodMissing to implement metods that
    # are the names of each emotion that will returen
    # the score of that specific emotion for the text
    def method_missing(emotion)
      return scores[emotion] || 0 if scores.keys.include? emotion

      raise NoMethodError, "#{emotion} is not defined"
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
      return unless SadPanda::Bank::EMOTIONS[emotion].include?(term)

      scores[emotion] += frequency
    end

    # Iterates all emotions for word in text
    def set_emotions(word, frequency)
      SadPanda::Bank::EMOTIONS.keys.each do |emotion|
        score_emotions(emotion, word, frequency)
      end
    end

    def score_emoticons
      scores[:ambiguous] += 1 if happy_emoticon?(words) && sad_emoticon?(words)
      scores[:joy] += 1 if happy_emoticon?(words)
      scores[:sadness] += 1 if sad_emoticon?(words)
    end

    # Logic to score all unique words in the text
    def score_words(word_frequencies)
      word_frequencies.each do |word, frequency|
        set_emotions(word, frequency)
      end

      score_emoticons

      ambiguous_score
    end
  end
end
