require 'spec_helper'

module SadPanda
	describe StatusMessage do

		let(:status_message) {SadPanda::StatusMessage.new "a message"}

		describe "has working methods" do
			it "has an emotion method" do
				status_message.respond_to?(:emotion)
			end

			it "has a polarity method" do
				status_message.respond_to?(:polarity)
			end

			it "has a create_term_frequency_hash_from_status_message method" do
				status_message.respond_to?(:create_term_frequency_hash_from_status_message)
			end

			it "has a get_emotion_score_from_words method" 

			it "has a get_term_polarity_hash method" 

			it "has a get_polarity_score_from_words method" 
		end

		describe "when initialized" do
			it "emotions are an empty hash" 

			it "emotion score is an empty hash" 

			it "polarities are an empty hash" 

			it "polarity score is an empty hash" 

			it "term_frequency_hash is an empty hash" 

			it "emotion_word_frequency is an empty hash" 
		end

		describe "when 'get_term_emotion_hash method' is called" do
			it 'returns a non-empty hash'
		end

		describe "when 'create_term_frequency_hash_from_status_message' method is called" do
			context "when status_message is an empty string" do
			end

			context "when status_message is a non-recogizable word" do
			end

			context "when status_message includes recognizable words" do
			end
		end

		describe "when 'get_word_stems' method is called" do
			context "when status_message is an empty string" do
			end

			context "when status_message is a non-recogizable word" do
			end

			context "when status_message includes recognizable words" do
			end
		end

		describe "when 'get_term_polarity_hash' method is called" do
			it "returns a non-empty hash"
		end

		describe "when polarity method is called" do

			it "returns a fixnum" do
				expect(status_message.polarity.class).to eql(Fixnum)
			end

			context "when status_message == 'my lobster collection makes me happy' " do
				it "emotion == 'joy' "
			end


			context "when status_message == 'sad' " do
				it "emotion == 'sadness' "
			end

			context "when status_message == 'angry' "  do
				it "emotion == 'anger' "
			end

			context "when status_message == 'I am ril afraid of cats, homie' " do
				it "emotion == 'fear' "
			end

			context "when status == 'I am disgusted' " do
				it "emotion == 'disguted'"
			end

			context "when status == 'I am so surprised'" do
				it "emotion == 'surprised'"

				it "has a polarity value"
			end

			context "when status_message == 'blarg' " do
				it "emotion == 'Uncertain' "
			end

			context "when status_message == '  ' " do 
				it "emotion is 'Uncertain'"
			end

		end

		describe "when emotion method is called" do

			it "returns a string" do
				expect(status_message.emotion.class).to eql(String)
			end

			context "when status_message == 'happy' " do
				it "polarity is greater than zero"
			end


			context "when status_message == 'sad' " do
				it "polarity is less than zero"
			end

			context "when status_message == 'angry' "  do
				it "polarity is less than zero"
			end

			context "when status_message == 'I am ril afraid of cats, homie' " do
				it "polarity is less than zero"
			end

			context "when status == 'I am disgusted' " do
				it "has a non-zero polarity value"
			end

			context "when status == 'I am so surprised'" do
				it "has a non-zero polarity value"
			end

			context "when status_message == 'blarg' " do
				it "polarity is zero"
			end

			context "when status_message == '  ' " do 
				it "polarity is zero"
			end

		end

	end
end