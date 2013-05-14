module classify_emotion
	class Emotion
		attr_reader :algorithm,:prior

		def initialize algorithm="bayes",prior=1.0,term_document_hash
			@term_document_hash = term_document_hash
			@algorithm = algorithm
			@prior = prior
		end 

		def classify_emotion message_text
			term_document_hash = create_term_document_hash
			emotions = []
			fo = File.open("emotions/emotions.csv","r")
			fo.each_line do |l|
				line = l.gsub("\r",",")
				words = line.split(",")
				words.each {|e| emotions << e}
			end
		end

	end
end