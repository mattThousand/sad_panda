module SadPanda
  # Helper methods for SadPanda
  module Helpers
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
      words - SadPanda::Stopwords
    end

    # Removes all the unwated characters from the text
    def words_in(text)
      text.downcase!
      text.tr!('!', '')
      text.tr!('?', '')

      # a.gsub!(/[^0-9A-Za-z]/, '')
      # This is the right fix to remove all special characters
      # But will have to refactor the emoji logic for it

      text.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/, '')
      text.gsub!(/(?=\w*h)(?=\w*t)(?=\w*t)(?=\w*p)\w*/, '')
      text.gsub!(/\s\s+/, ' ')
      text.split(' ')
    end
  end
end
