def classify_emotion message_text,algorithm="bayes",prior=1.0
	term_document_hash = create_term_document_hash message_text
	emotions = []
	fo = File.open("emotions/emotions.csv","r")
	fo.each_line do |l|
		line = l.gsub("\r",",")
		words = line.split(",")
		words.each {|e| emotions << e}
	end
end