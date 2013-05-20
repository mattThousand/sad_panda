require 'spec_helper'

module SadPanda
	describe StatusMessage do

		let(:status_message) {SadPanda::StatusMessage.new "a message"}
		let(:emotions) {status_message.get_term_emotions}
		let(:polarities) {status_message.get_term_polarities}
		let(:term_frequencies) {status_message.build_term_frequencies}

		describe "when initialized" do
			it "verbose defaults to false" do
				expect(status_message.verbose).to be_false
			end
		end

		describe "when 'build_term_frequencies' method is called" do
			context "when status_message is an empty string" do
				it "returns an empty hash" do
					empty_message = SadPanda::StatusMessage.new "   "
					expect(empty_message.build_term_frequencies).to be_empty
				end
			end

			context "when status_message is a non-recogizable word" do
				it "returns a empty hash with key == zorg and and value == 1" do
					word = "zorg"
					strange_message = SadPanda::StatusMessage.new word
					expect(strange_message.build_term_frequencies).to eql({"zorg" => 1})
				end
			end

			context "when status_message includes recognizable words" do
				it "returns a non-empty hash" do
					hash = status_message.build_term_frequencies
					expect(hash).to_not be_empty
				end
			end
		end

		describe "when 'get_term_emotions method' is called" do
			it 'returns a hash' do
				output = status_message.get_term_emotions
				expect(output.class).to eql(Hash)
			end

			it "is non-empty" do
				output = status_message.get_term_emotions
				expect(output).to_not be_empty
			end
		end

		describe "when 'get_term_polarities' method is called" do
			it "returns a hash" do
				output = status_message.get_term_polarities
				expect(output.class).to eql(Hash)
			end

			it "is non empty" do
				output = status_message.get_term_polarities
				expect(output).to_not be_empty
			end
		end

		describe "when 'get_emotion_score' method is called" do
			it 'returns a string' do
				output = status_message.get_emotion_score emotions,term_frequencies
				expect(output.class).to eql(String)
			end
		end

		describe "when 'get_polarity_score' method is called" do
			it 'returns a string' do
				output = status_message.get_polarity_score polarities,term_frequencies
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

			context "when status_message == 'I am happy' " do
				it "polarity is greater than zero" do
					status_message = SadPanda::StatusMessage.new "I am happy"
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
					status_message = SadPanda::StatusMessage.new "I am fearful"
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