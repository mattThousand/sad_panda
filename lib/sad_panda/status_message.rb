require 'lingua/stemmer'

module SadPanda

	class StatusMessage

		attr_accessor :emotion_word_frequency, :emotion_score, :term_frequency_hash, :emotions, :polarities, :polarity_score
		attr_reader :stemmer

		def initialize message, verbose=false
			@message = message
			@stemmer = Lingua::Stemmer.new(:language => "en")
			@emotion_word_frequency = {}
			@emotions = {}
			@polarities = {}
			@term_frequency_hash = {}
			@emotion_score = {}
			@verbose = verbose
			@polarity_score = {}
		end

		def get_term_emotion_hash
			fo = File.open("lib/sad_panda/emotions/emotions.csv","r")
			lines = fo.read.split("\r")
			lines = lines[0].split("\n")
			fo.close
			lines.each do |l|
				word,emotion = l.split(",")
				@emotions[emotion] ||= []
				@emotions[emotion] << word
			end
			@emotions
		end

		def get_emotion_score_from_words emotions_hash,word_frequency_hash
			word_frequency_hash.each do |key,value|
				emotions_hash.keys.each do |k|
					if emotions_hash[k].include?(key)
						@emotion_score[k] ||= 0
						@emotion_score[k] += value
					end
				end
			end
			if @verbose
				@emotion_score.keys.each do |key|
					puts "EMOTION: "+key
					puts "SCORE: "+@emotion_score[key]
				end
			end
				# return an emotion_score_hash to be processed by emotion
				if @emotion_score == {}
					puts "hrm...  You are difficult to read. Enter something more emotional please..."
					exit
				else
					@emotion_score.max_by{|k,v| v}[0]
				end
		end

		def emotion 
			# get the emotion for which the emotion score value is highest
			get_emotion_score_from_words(self.get_term_emotion_hash,self.create_term_frequency_hash)
		end

		def get_term_polarity_hash
			fo = File.open("lib/sad_panda/emotions/subjectivity.csv","r")
			lines = fo.read.split("\r")
			fo.close
			lines.each do |l|
				word,strength,polarity = l.split(",")
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

		def get_polarity_score_from_words polarity_hash,word_frequency_hash
			word_frequency_hash.each do |key,value|
				polarity_hash.keys.each do |k|
					if k.include?(key)
						@polarity_score[k] ||= 0
						@polarity_score[k] += (polarity_hash[k].to_f*value.to_f)/word_frequency_hash.length
					end
				end
			end
			if @verbose
				@polarity_score.keys.each do |key|
					puts "POLARITY: "+key
					puts "SCORE: "+@polarity_score[key]
				end
			end
				# return an polarity_score_hash to be processed by polarity
				if @polarity_score == {}
					puts "hrm...  You are difficult to read. Enter something more emotional please..."
					exit
				else
					@polarity_score.max_by{|k,v| v}[1]
				end
		end

		def polarity 
			# get the polarity for which the polarity score value is highest
			get_polarity_score_from_words(self.get_term_polarity_hash,self.create_term_frequency_hash)
		end		

		def create_term_frequency_hash message_text=@message

			stopwords=["i","a", "a's", "able", "about", "above", "according", "accordingly", "across", "actually", "after", "afterwards", "again", "against", "ain't", "all", "allow", "allows", "almost", "alone", "along", "already", "also", "although", "always", "am", "among", "amongst", "an", "and", "another", "any", "anybody", "anyhow", "anyone", "anything", "anyway", "anyways", "anywhere", "apart", "appear", "appreciate", "appropriate", "are", "aren't", "around", "as", "aside", "ask", "asking", "associated", "at", "available", "away", "awfully", "b", "be", "became", "because", "become", "becomes", "becoming", "been", "before", "beforehand", "behind", "being", "believe", "below", "beside", "besides", "best", "better", "between", "beyond", "both", "brief", "but", "by", "c", "c'mon", "c's", "came", "can", "can't", "cannot", "cant", "cause", "causes", "certain", "certainly", "changes", "clearly", "co", "com", "come", "comes", "concerning", "consequently", "consider", "considering", "contain", "containing", "contains", "corresponding", "could", "couldn't", "course", "currently", "d", "definitely", "described", "despite", "did", "didn't", "different", "do", "does", "doesn't", "doing", "don't", "done", "down", "downwards", "during", "e", "each", "edu", "eg", "eight", "either", "else", "elsewhere", "enough", "entirely", "especially", "et", "etc", "even", "ever", "every", "everybody", "everyone", "everything", "everywhere", "ex", "exactly", "example", "except", "f", "far", "few", "fifth", "first", "five", "followed", "following", "follows", "for", "former", "formerly", "forth", "four", "from", "further", "furthermore", "g", "get", "gets", "getting", "given", "gives", "go", "goes", "going", "gone", "got", "gotten", "greetings", "h", "had", "hadn't", "happens", "hardly", "has", "hasn't", "have", "haven't", "having", "he", "he's", "hello", "help", "hence", "her", "here", "here's", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "hi", "him", "himself", "his", "hither", "hopefully", "how", "howbeit", "however", "i", "i'd", "i'll", "i'm", "i've", "ie", "if", "ignored", "immediate", "in", "inasmuch", "inc", "indeed", "indicate", "indicated", "indicates", "inner", "insofar", "instead", "into", "inward", "is", "isn't", "it", "it'd", "it'll", "it's", "its", "itself", "j", "just", "k", "keep", "keeps", "kept", "know", "knows", "known", "l", "last", "lately", "later", "latter", "latterly", "least", "less", "lest", "let", "let's", "like", "liked", "likely", "little", "look", "looking", "looks", "ltd", "m", "mainly", "many", "may", "maybe", "me", "mean", "meanwhile", "merely", "might", "more", "moreover", "most", "mostly", "much", "must", "my", "myself", "n", "name", "namely", "nd", "near", "nearly", "necessary", "need", "needs", "neither", "never", "nevertheless", "new", "next", "nine", "no", "nobody", "non", "none", "noone", "nor", "normally", "not", "nothing", "novel", "now", "nowhere", "o", "obviously", "of", "off", "often", "oh", "ok", "okay", "old", "on", "once", "one", "ones", "only", "onto", "or", "other", "others", "otherwise", "ought", "our", "ours", "ourselves", "out", "outside", "over", "overall", "own", "p", "particular", "particularly", "per", "perhaps", "placed", "please", "plus", "possible", "presumably", "probably", "provides", "q", "que", "quite", "qv", "r", "rather", "rd", "re", "really", "reasonably", "regarding", "regardless", "regards", "relatively", "respectively", "right", "s", "said", "same", "saw", "say", "saying", "says", "second", "secondly", "see", "seeing", "seem", "seemed", "seeming", "seems", "seen", "self", "selves", "sensible", "sent", "serious", "seriously", "seven", "several", "shall", "she", "should", "shouldn't", "since", "six", "so", "some", "somebody", "somehow", "someone", "something", "sometime", "sometimes", "somewhat", "somewhere", "soon", "sorry", "specified", "specify", "specifying", "still", "sub", "such", "sup", "sure", "t", "t's", "take", "taken", "tell", "tends", "th", "than", "thank", "thanks", "thanx", "that", "that's", "thats", "the", "their", "theirs", "them", "themselves", "then", "thence", "there", "there's", "thereafter", "thereby", "therefore", "therein", "theres", "thereupon", "these", "they", "they'd", "they'll", "they're", "they've", "think", "third", "this", "thorough", "thoroughly", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "took", "toward", "towards", "tried", "tries", "truly", "try", "trying", "twice", "two", "u", "un", "under", "unfortunately", "unless", "unlikely", "until", "unto", "up", "upon", "us", "use", "used", "useful", "uses", "using", "usually", "uucp", "v", "value", "various", "very", "via", "viz", "vs", "w", "want", "wants", "was", "wasn't", "way", "we", "we'd", "we'll", "we're", "we've", "welcome", "well", "went", "were", "weren't", "what", "what's", "whatever", "when", "whence", "whenever", "where", "where's", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "who's", "whoever", "whole", "whom", "whose", "why", "will", "willing", "wish", "with", "within", "without", "won't", "wonder", "would", "would", "wouldn't", "x", "y", "yes", "yet", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves", "z", "zero"]


			message_text = @message.gsub(/[^a-z ]/i, '').downcase
			message_text = message_text.gsub(/\s\s+/,' ')
			words = message_text.split(" ")

			#filter for english stopwords
			words.each do |word|
				if stopwords.include?(word)
					words = words-[word]
				end
			end

			#get word stems
			word_stems = get_word_stems words

			#create term_frequency_hash
			word_stems.each do |stem|
				@term_frequency_hash[stem] = word_stems.count(stem)
			end

			#return term frequency matrix
			@term_frequency_hash
		end

		def get_word_stems words
			output = []
			words.each do |word|
				output << @stemmer.stem(word)
			end
			output
		end

	end
end