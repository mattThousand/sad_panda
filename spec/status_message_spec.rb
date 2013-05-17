require 'spec_helper'

module SadPanda
	describe StatusMessage do

		let(:status_message) {SadPanda::StatusMessage.new "a message"}
		let(:emotions_hash) {status_message.get_term_emotion_hash}
		let(:polarities_hash) {status_message.get_term_polarity_hash}
		let(:term_frequency_hash) {status_message.create_term_frequency_hash_from_status_message}		

		describe "has working methods" do
			it "has an emotion method" do
				expect(status_message.respond_to?(:emotion)).to eql(true)
			end

			it "has a polarity method" do
				expect(status_message.respond_to?(:polarity)).to eql(true)
			end

			it "has a create_term_frequency_hash_from_status_message method" do
				expect(status_message.respond_to?(:create_term_frequency_hash_from_status_message)).to eql(true)
			end

			it "has a get_emotion_score_from_words method" do
				expect(status_message.respond_to?(:get_emotion_score_from_words)).to eql(true)
			end

			it "has a get_term_polarity_hash method" do
				expect(status_message.respond_to?(:get_emotion_score_from_words)).to eql(true)
			end

			it "has a get_polarity_score_from_words method" do
				expect(status_message.respond_to?(:get_emotion_score_from_words)).to eql(true)
			end

		end

		describe "when initialized" do
			it "verbose defaults to false" do
				expect(status_message.verbose).to eql(false)
			end
		end

		describe "when 'create_term_frequency_hash_from_status_message' method is called" do
			context "when status_message is an empty string" do
				it "returns an empty hash" do
					empty_message = SadPanda::StatusMessage.new "   "
					expect(empty_message.create_term_frequency_hash_from_status_message).to eql({})
				end
			end

			context "when status_message is a non-recogizable word" do
				it "returns a empty hash with key == zorg and and value == 1" do
					strange_message = SadPanda::StatusMessage.new "zorg"
					expect(strange_message.create_term_frequency_hash_from_status_message).to eql({"zorg"=>1})
				end
			end

			context "when status_message includes recognizable words" do
				it "returns a non-empty hash" do
					length = status_message.create_term_frequency_hash_from_status_message.length
					expect(length).to be > 0 
				end 
			end
		end

		describe "when 'get_word_stems' method is called" do
			context "when word is an empty string" do
				it "returns an array of itself" do
					expect(status_message.get_word_stems [' ']).to eql([' '])
				end
			end

			context "when word is a non-recogizable word" do
				it "returns an array containing itself" do
					expect(status_message.get_word_stems ['zorg']).to eql(['zorg'])
				end
			end

			context "when word is a recognizable word" do
				it "returns a string" do
					stem = status_message.get_word_stems ['purple']
					expect(stem[0].class).to eql(String)
				end
			end
		end

		describe "when 'get_term_emotion_hash method' is called" do
			it 'returns a hash' do
				output = status_message.get_term_emotion_hash
				expect(output.class).to eql(Hash)
			end

			it "is non-empty" do 
				output = status_message.get_term_emotion_hash
				expect(output.length).to be > 0
			end
		end

		describe "when 'get_term_polarity_hash' method is called" do
			it "returns a hash" do
				output = status_message.get_term_polarity_hash
				expect(output.class).to eql(Hash)
			end

			it "is non empty" do
				output = status_message.get_term_polarity_hash
				expect(output.length).to be > 0
			end
		end

		describe "when 'get_emotion_score_from_words' method is called" do
			it 'returns a string' do
				output = status_message.get_emotion_score_from_words emotions_hash,term_frequency_hash
				expect(output.class).to eql(String)
			end
		end

		describe "when 'get_polarity_score_from_words' method is called" do
			it 'returns a string' do
				output = status_message.get_polarity_score_from_words polarities_hash,term_frequency_hash
				expect(output.class).to eql(Fixnum)
			end
		end


		describe "when polarity method is called" do

			it "returns a fixnum" do
				expect(status_message.polarity.class).to eql(Fixnum)
			end

			context "when status_message == 'my lobster collection makes me happy' " do
				it "emotion == 'joy' " do
					status_message = SadPanda::StatusMessage.new "my lobster collection makes me happy"
					expect(status_message.emotion).to eql("joy")
				end
			end

			context "when status_message == 'sad' " do
				it "emotion == 'sadness' " do
					status_message = SadPanda::StatusMessage.new "sad"
					expect(status_message.emotion).to eql("sadness")
				end
			end

			context "when status_message == 'angry' "  do
				it "emotion == 'anger' " do
					status_message = SadPanda::StatusMessage.new "angry"
					expect(status_message.emotion).to eql('anger')
				end
			end

			context "when status_message == 'I am ril afraid of cats, homie' " do
				it "emotion == 'fear' " do
					status_message = SadPanda::StatusMessage.new "I am ril afraid of cats, homie"
					expect(status_message.emotion).to eql("fear")
				end
			end

			context "when status == 'I am disgusted' " do
				it "emotion == 'disgust'" do
					status_message = SadPanda::StatusMessage.new "I am disgusted"
					expect(status_message.emotion).to eql('disgust')
				end
			end

			context "when status == 'I am so surprised'" do
				it "emotion == 'surprise'" do
					status_message = SadPanda::StatusMessage.new "I am so surprised"
					expect(status_message.emotion).to eql('surprise')
				end
			end

			context "when status_message == 'blarg' " do
				it "emotion == 'Uncertain' " do
					status_message = SadPanda::StatusMessage.new "blarg"
					expect(status_message.emotion).to eql('Uncertain')
				end
			end

			context "when status_message == '  ' " do 
				it "emotion is 'Uncertain'" do
					status_message = SadPanda::StatusMessage.new "  "
				end
			end

		end

		describe "when emotion method is called" do

			it "returns a string" do
				expect(status_message.emotion.class).to eql(String)
			end

			context "when status_message == 'I am paralyzed by happinesss' " do
				it "polarity is greater than zero" do
					status_message = SadPanda::StatusMessage.new "I am paralyzed by happinesss"
					expect(status_message.polarity).to be > 0
				end 
			end


			context "when status_message == 'sad' " do
				it "polarity is less than zero" do
					status_message = SadPanda::StatusMessage.new "sad"
					expect(status_message.polarity).to be < 0
				end
			end

			context "when status_message == 'angry' "  do
				it "polarity is less than zero" do
					status_message = SadPanda::StatusMessage.new "angry"
					expect(status_message.polarity).to be < 0
				end
			end

			context "when status_message == 'I am terrified' " do
				it "polarity is less than zero" do
					status_message = SadPanda::StatusMessage.new "I am terrified"
					expect(status_message.polarity).to be < 0
				end
			end

			context "when status == 'I am disgusted' " do
				it "has a non-zero polarity value" do
					status_message = SadPanda::StatusMessage.new "I am disgusted"
					expect(status_message.polarity).to be < 0
				end
			end

			context "when status == 'This is surprising'" do
				it "has a non-zero polarity value" do
					status_message = SadPanda::StatusMessage.new "This is surprising"
					expect(status_message.polarity).to_not eql(0)
				end
			end

			context "when status_message == 'blarg' " do
				it "polarity is zero" do
					status_message = SadPanda::StatusMessage.new "blarg"
					expect(status_message.polarity).to  eql(0)
				end
			end

			context "when status_message == '  ' " do 
				it "polarity is zero" do
					status_message = SadPanda::StatusMessage.new "  "
					expect(status_message.polarity).to eql(0)
				end
			end

		end

	end
end