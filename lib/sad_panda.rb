require_relative "./sad_panda/version"
require_relative './sad_panda/emotions/emotion_bank.rb'
require_relative './sad_panda/emotions/term_polarities.rb'
require_relative './sad_panda/emotions/stopwords.rb'
require 'lingua/stemmer'

module SadPanda

	# this method reads the text of the status message
	# inputed by the user, removes common english words,
	# strips punctuation and capitalized letters, isolates
	# the stem of the word, and ultimately produces a hash
	# where the keys are the stems of the remaining words,
	# and the values are their respective frequencies within
	# the status message
	def self.build_term_frequencies message

		@message = message

		# create empty term_frequencies
		term_frequencies = {}

		# clean the text of the status message
		if (@message.include?(":)") || @message.include?(":-)") || @message.include?(":]") || @message.include?(":-]"))
			@happy_que = true
		end
		if (@message.include?(":(") || @message.include?(":-(") || @message.include?(":[") || @message.include?(":-["))
			@sad_que = true
		end

		message_text = @message.gsub(/[^a-z ]/i, '').downcase
    message_text.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/, '')
    message_text.gsub!(/(?=\w*h)(?=\w*t)(?=\w*t)(?=\w*p)\w*/, '')
    message_text.gsub!(/\s\s+/,' ')
		words = message_text.split(" ")

		#filter for english stopwords
		stopwords = Stopwords.stopwords
		words = words - stopwords

		#get word stems
		word_stems = SadPanda.get_word_stems words

		#create term_frequencies
		word_stems.each do |stem|
			term_frequencies[stem] = word_stems.count(stem)
		end

		#return term frequency matrix
		term_frequencies
	end

	# this method takes an array of words an returns an array of word stems
	def self.get_word_stems words
		@stemmer = Lingua::Stemmer.new(:language => "en")
		output = []
		words.each do |word|
			output << @stemmer.stem(word)
		end
		output
	end

	# this method takes an emotion-words hash and a hash containing word
	# frequencies for the status message, calculates a numerical score
	# for each possble emotion, and returns the emotion with the highest
	# "score"
	def self.get_emotion_score(emotions, term_frequencies, verbose = false)
		emotion_score = {}
		term_frequencies.each do |key,value|
			emotions.keys.each do |k|
				if emotions[k].include?(key)
					emotion_score[k] ||= 0
					emotion_score[k] += value
				end
			end
		end
		if @verbose
			emotion_score.keys.each do |key|
				puts "EMOTION: "+key
				puts "SCORE: "+emotion_score[key].to_s
			end
		end
		# return an emotion_score_hash to be processed by emotion
    # get clue from any emoticons present
    if (@happy_que && @sad_que)
        return "ambiguous"
    elsif @happy_que
        return "joy"
    elsif @sad_que
        return "sadness"
    else
		## 0 if unable to detect emotion
      if emotion_score == {}
          return "ambiguous"
      else
          score = emotion_score.max_by{|k, v| v}[0]
      end
      score
    end
	end

	# this method returns the best-fit emotion for the status message
	def self.emotion message
    # get the emotion for which the emotion score value is highest
    if @emotions
        SadPanda.get_emotion_score(@emotions, SadPanda.build_term_frequencies(message))
    else
        SadPanda.get_emotion_score(EmotionBank.get_term_emotions, build_term_frequencies(message))
    end
	end

	# this method gives the status method a normalized polarity
	# value based on the words it contains
	def self.get_polarity_score (polarity_hash, term_frequencies, verbose = false)
		polarity_scores = []
		term_frequencies.each do |key, value|
			polarity_hash.keys.each do |k|
				if key == k
					polarity_scores << (polarity_hash[k].to_f)
				end
			end
		end

		# return an polarity_score_hash to be processed by polarity method
		# return an emotion_score_hash to be processed by emotion
    # get clue from any emoticons present
    if (@happy_que && @sad_que)
        score = 5
    elsif @happy_que
        score = 8
    elsif @sad_que
        score = 2
    else
			if polarity_scores == []
				# polarity unreadable; return a neutral score of zero
				score = 5
			else
				score = polarity_scores.inject(0.0){ |sum, el| sum + el}/polarity_scores.length
				polarity_scores = []
			end
			if @verbose
				puts "POLARITY: " + score.to_s
			end
			score
		end
	end

	# this method returns the polarity value for the status message
	# (normalized by the number of 'polar' words that the status
	# message contains)
	def self.polarity message
		# get the polarity for which the polarity score value is highest
		if @polarities
			SadPanda.get_polarity_score(@polarities, SadPanda.build_term_frequencies(message))
		else
			SadPanda.get_polarity_score(TermPolarities.get_term_polarities, SadPanda.build_term_frequencies(message))
		end
	end

end
