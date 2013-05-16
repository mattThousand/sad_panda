require 'test_helper'

module SadPanda
	describe StatusMessage do

		before(:each) do
			@status_message = SadPanda::StatusMessage.new "a message"
		end

		describe "has an emotion method" do
		end

		describe "has a polarity method" do
		end

		describe "has a create_term_frequency_hash_from_status_message method" do
		end

		describe "has a get_emotion_score_from_words method" do
		end

		describe "has a get_term_polarity_hash method" do
		end

		describe "has a get_polarity_score_from_words method" do
		end

		describe "when initialized" do
			it "emotions are an empty hash" do 
			end

			it "emotion score is an empty hash" do
			end

			it "polarities are an empty hash" do
			end

			it "polarity score is an empty hash" do
			end

			it "term_frequency_hash is an empty hash" do
			end

			it "emotion_word_frequency is an empty hash" do
			end
		end

		describe "when emotion method is called" do
		end

		describe "when polarities method is called" do
		end

	end
end