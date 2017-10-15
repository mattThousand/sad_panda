module SadPanda
  # Helper methods for SadPanda
  module Helpers
    def sad_emojies
      [':(', ':-(', ':[', ':-[']
    end

    def happy_emojies
      [':)', ':-)', ':]', ':-]']
    end

    # Returns a Hash of frequencies of each uniq word in the text
    def frequencies_for(words)
      word_frequencies = {}
      words.each { |word| word_frequencies[word] = words.count(word) }
      word_frequencies
    end

    # Converts all the words to its stem form
    def stems_for(words)
      stemmer = Lingua::Stemmer.new(language: 'en')
      words.map! { |word| stemmer.stem(word) }
    end

    # Strips the words array of stop words
    def remove_stopwords_in(words)
      words - SadPanda::Bank::STOPWORDS
    end

    # Captures and returns emojies in the text
    def emojies_in(text)
      (sad_emojies + happy_emojies).map do |emoji|
        text.scan(emoji)
      end.flatten
    end

    # Removing non ASCII characters from text
    def sanitize(text)
      text.gsub!(/[^a-z ]/i, '')
      text.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/, '')
      text.gsub!(/(?=\w*h)(?=\w*t)(?=\w*t)(?=\w*p)\w*/, '')
      text.gsub!(/\s\s+/, ' ')

      text.downcase    
    end

    # Removes all the unwated characters from the text
    def words_in(text)
      emojies_in(text) + sanitize(text).split
    end

    # Checks if words has a happy emoji
    def happy_emoticon?(words)
      (happy_emojies & words).any?
    end

    # Checks if words has a sad emoji
    def sad_emoticon?(words)
      (sad_emojies & words).any?
    end
  end
end
