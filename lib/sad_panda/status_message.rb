require 'lingua/stemmer'

module SadPanda

	class StatusMessage

		attr_accessor :message, :verbose
		attr_reader :stemmer

		def initialize(message, verbose = false)
			@message = message
			@stemmer = Lingua::Stemmer.new(:language => "en")
			@verbose = verbose
		end

		# this method reads a csv file containing 'word,emotion' pairs,
		# and groups them into a hash where the keys are the 6 available
		# emotions ("anger", "disgust", "joy", "surprise", "fear", "sadness")
		# and the values are the words associated with them
		def get_term_emotions
			@emotions = {}
			fo = File.open("lib/sad_panda/emotions/emotions.csv", "r")
			lines = fo.read.split("\r")
			lines = lines[0].split("\n")
			fo.close
			lines.each do |l|
				word, emotion = l.split(",")
				@emotions[emotion] ||= []
				@emotions[emotion] << word
			end
			@emotions
		end


		# this method reads the text of the status message
		# inputed by the user, removes common english words,
		# strips punctuation and capitalized letters, isolates
		# the stem of the word, and ultimately produces a hash
		# where the keys are the stems of the remaining words,
		# and the values are their respective frequencies within
		# the status message
		def build_term_frequencies

			# create empty term_frequencies
			term_frequencies = {}

			# common english words are hard-coded as an array - is there a more efficient way to do this?
			stopwords = %w{i a a's able about above according accordingly across actually after
			afterwards again against ain't all allow allows almost alone along already also although
			always am among amongst an and another any anybody anyhow anyone anything anyway anyways
			anywhere apart appear appreciate appropriate are aren't around as aside ask asking associated
			at available away awfully b be became because become becomes becoming been before beforehand
			behind being believe below beside besides best better between beyond both brief but by c c'mon
			c's came can can't cannot cant cause causes certain certainly changes clearly co com come comes
			concerning consequently consider considering contain containing contains corresponding could couldn't
			course currently d definitely described despite did didn't different do does doesn't doing don't
			done down downwards during e each edu eg eight either else elsewhere enough entirely especially et
			etc even ever every everybody everyone everything everywhere ex exactly example except f far few
			fifth first five followed following follows for former formerly forth four from further furthermore
			g get gets getting given gives go goes going gone got gotten greetings h had hadn't happens hardly
			has hasn't have haven't having he he's hello help hence her here here's hereafter hereby herein
			hereupon hers herself hi him himself his hither hopefully how howbeit however i i'd i'll i'm
			i've ie if ignored immediate in inasmuch inc indeed indicate indicated indicates inner insofar
			instead into inward is isn't it it'd it'll it's its itself j just k keep keeps kept know knows known
			l last lately later latter latterly least less lest let let's like liked likely little look looking
			looks ltd m mainly many may maybe me mean meanwhile merely might more moreover most mostly much must
			my myself n name namely nd near nearly necessary need needs neither never nevertheless new next nine
			no nobody non none noone nor normally not nothing novel now nowhere o obviously of off often oh ok
			okay old on once one ones only onto or other others otherwise ought our ours ourselves out outside
			over overall own p particular particularly per perhaps placed please plus possible presumably probably
			provides q que quite qv r rather rd re really reasonably regarding regardless regards relatively
			respectively right s said same saw say saying says second secondly see seeing seem seemed seeming
			seems seen self selves sensible sent serious seriously seven several shall she should shouldn't since
			six so some somebody somehow someone something sometime sometimes somewhat somewhere soon sorry specified
			specify specifying still sub such sup sure t t's take taken tell tends th than thank thanks thanx that
			that's thats the their theirs them themselves then thence there there's thereafter thereby therefore therein
			theres thereupon these they they'd they'll they're they've think third this thorough thoroughly those
			though three through throughout thru thus to together too took toward towards tried tries truly try
			trying twice two u un under unfortunately unless unlikely until unto up upon us use used useful uses using
			usually uucp v value various very via viz vs w want wants was wasn't way we we'd we'll we're we've welcome
			well went were weren't what what's whatever when whence whenever where where's whereafter whereas whereby
			wherein whereupon wherever whether which while whither who who's whoever whole whom whose why will willing wish
			with within without won't wonder would would wouldn't x y yes yet you you'd you'll you're you've your yours
			yourself yourselves z zero}

			# clean the text of the status message
			message_text = @message.gsub(/[^a-z ]/i, '').downcase
			message_text = message_text.gsub(/\s\s+/,' ')
			words = message_text.split(" ")

			#filter for english stopwords
			words = words - stopwords

			#get word stems
			word_stems = get_word_stems words

			#create term_frequencies
			word_stems.each do |stem|
				term_frequencies[stem] = word_stems.count(stem)
			end

			#return term frequency matrix
			term_frequencies
		end

		# this method takes an array of words an returns an array of word stems
		def get_word_stems words
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
		def get_emotion_score(emotions, term_frequencies)
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
				## 0 if unable to detect emotion
				if emotion_score == {}
					return "Uncertain"
				else
					score = emotion_score.max_by{|k, v| v}[0]
				end
				score
		end

		# this method returns the best-fit emotion for the status message
		def emotion
			# get the emotion for which the emotion score value is highest
			if @emotions
				get_emotion_score(@emotions, build_term_frequencies)
			else
				get_emotion_score(get_term_emotions, build_term_frequencies)
			end
		end

		# this method reads a csv file containing 'word,severity,positive/negative'
		# triplits, and returns a giant hash where the keys are individual words
		# and the values range between -2 and 2 (-2 being more negative, 2 being most positive)
		def get_term_polarities
			@polarities = {}
			fo = File.open("lib/sad_panda/emotions/subjectivity.csv", "r")
			lines = fo.read.split("\r")
			fo.close
			lines.each do |l|
				word, strength, polarity = l.split(",")
				if strength == "strongsubj"
					strength = 1
				else
					strength = 2
				end
				if polarity == "positive"
					polarity = 1
				else
					polarity = -1
				end
				@polarities[word] ||= 0
				@polarities[word] = polarity*strength
			end
			@polarities
		end

		# this method gives the status method a normalized polarity
		# value based on the words it contains
		def get_polarity_score (polarity_hash, term_frequencies)
			polarity_score = {}
			term_frequencies.each do |key, value|
				polarity_hash.keys.each do |k|
					if key == k
						polarity_score[k] = (polarity_hash[k].to_f * value.to_f) / term_frequencies.length
					elsif k.include?(key) && !polarity_score[key]
						polarity_score[key] ||= 0
						polarity_score[key] += (polarity_hash[k].to_f * value.to_f) / term_frequencies.length
					end
				end
			end

				# return an polarity_score_hash to be processed by polarity method

			if polarity_score == {}
				# polarity unreadable; return a neutral score of zero
				score = 0
			else
				score = polarity_score.max_by{|k, v| v}[1]
				polarity_score = {}
			end
			if @verbose
				puts "POLARITY: " + score.to_s
			end
			score
		end

		# this method returns the polarity value for the status message
		# (normalized by the number of 'polar' words that the status
		# message contains)
		def polarity
			# get the polarity for which the polarity score value is highest
			if @polarities
				get_polarity_score(@polarities, build_term_frequencies)
			else
				get_polarity_score(get_term_polarities, build_term_frequencies)
			end
		end

	end
end