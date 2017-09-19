require 'sad_panda/emotions/emotion_bank'
require 'sad_panda/emotions/term_polarities'
require 'sad_panda/emotions/stopwords'
require 'sad_panda/emotion'
require 'sad_panda/polarity'
require 'lingua/stemmer'

# SadPanda main module
module SadPanda
  # this method returns the best-fit emotion for the status message
  def self.emotion(text)
    # get the emotion for which the emotion score value is highest
    SadPanda::Emotion.new(text).call
  end

  # this method returns the polarity value for the status message
  # (normalized by the number of 'polar' words that the status
  # message contains)
  def self.polarity(text)
    # get the polarity for which the polarity score value is highest
    SadPanda.polarity_score(text,
                            SadPanda::Polarities,
                            term_frequencies(text))
  end

  private

  def self.term_frequencies(message)
    words = words_from_message_text(message)
    words = words - SadPanda::Stopwords

    word_stems = SadPanda.word_stems words
    create_term_frequencies(word_stems)
  end

  def self.word_stems(words)
    stemmer = Lingua::Stemmer.new(language: 'en')
    words.map { |word| stemmer.stem(word) }
  end

  def self.emotion_score(message, emotions, term_frequencies, emotion_score = {})
    term_frequencies.each do |key, value|
      set_emotions(emotions, emotion_score, key, value)
    end

    check_emoticon_for_emotion(emotion_score, message)
  end

  def self.polarity_score(message, polarity_hash, term_frequencies, polarity_scores = [])
    term_frequencies.each do |key, value|
      set_polarities(key, value, polarity_hash, polarity_scores)
    end

    check_emoticon_for_polarity(polarity_scores, message)
  end

  def self.happy_emoticon(message)
    message.include?(':)') ||
      message.include?(':-)') ||
      message.include?(':]') || message.include?(':-]')
  end

  def self.sad_emoticon(message)
    message.include?(':(') ||
      message.include?(':-(') ||
      message.include?(':[') || message.include?(':-[')
  end

  def self.words_from_message_text(message)
    message.gsub!(/[^a-z ]/i, '')
    message.downcase!
    message.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/, '')
    message.gsub!(/(?=\w*h)(?=\w*t)(?=\w*t)(?=\w*p)\w*/, '')
    message.gsub!(/\s\s+/,' ')
    message.split(' ')
  end

  def self.set_emotions(emotions, emotion_score, term, frequency)
    emotions.keys.each do |k|
      store_emotions(emotions, emotion_score, k, term, frequency)
    end
  end

  def self.set_polarities(term, frequency, polarity_hash, polarity_scores)
    polarity_hash.keys.each do |k|
      store_polarities(term, k, polarity_hash, polarity_scores)
    end
  end

  def self.store_emotions(emotions, emotion_score, emotion, term, frequency)
    return unless emotions[emotion].include?(term)

    emotion_score[emotion] ||= 0
    emotion_score[emotion] += frequency
  end

  def self.store_polarities(term, word, polarity_hash, polarity_scores)
    polarity_scores << polarity_hash[word].to_f if term.to_sym == word
  end

  def self.check_emoticon_for_emotion(emotion_score, message)
    return :ambiguous if happy_emoticon(message) && sad_emoticon(message)
    return :joy if happy_emoticon(message)
    return :sadness if sad_emoticon(message)

    return_emotion_score(emotion_score)
  end

  def self.return_emotion_score(emotion_score)
    # 0 if unable to detect emotion
    return :ambiguous if emotion_score.empty?

    emotion_score.max_by { |value| value }[0]
  end

  def self.check_emoticon_for_polarity(polarity_scores, message)
    return 5 if happy_emoticon(message) && sad_emoticon(message)
    return 8 if happy_emoticon(message)
    return 2 if sad_emoticon(message)

    return_polarity_scores(polarity_scores)
  end

  def self.return_polarity_scores(polarity_scores)
    # polarity unreadable; return a neutral score of 5
    return 5 if polarity_scores.empty?

    polarity_scores.inject(0.0) { |sum, el| sum + el } / polarity_scores.length
  end

  def self.create_term_frequencies(words)
    frequencies = {}
    words.each { |word| frequencies[word] = words.count(word) }

    frequencies
  end
end
