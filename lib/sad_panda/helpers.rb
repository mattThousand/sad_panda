module SadPanda
  # Helper methods for SadPanda
  module Helpers
    # Returns a Hash of frequencies of each uniq word in the text
    def get_frequencies_for(words)
      word_frequencies = {}
      words.each { |word| word_frequencies[word] = words.count(word) }
      word_frequencies
    end

    # Converts all the words to its stem form
    def stems_for(words)
      stemmer = Lingua::Stemmer.new(language: 'en')
      words.map! { |word| stemmer.stem(word) }
    end

    # Strps the words of stop words
    def remove_stopwords(words)
      # binding.pry
      words - SadPanda::Stopwords
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
