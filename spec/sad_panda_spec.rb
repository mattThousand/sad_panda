require 'spec_helper'


describe SadPanda  do

  let(:emotions) {EmotionBank.get_term_emotions}
  let(:polarities) {TermPolarities.get_term_polarities}
  let(:term_frequencies) {SadPanda.build_term_frequencies("My cactus collection makes me happy.")}

  describe "when 'build_term_frequencies' method is called" do

    context "when status_message is an empty string" do
      it "returns an empty hash" do
        empty_message = "   "
        expect(SadPanda.build_term_frequencies(empty_message)).to be_empty
      end
    end

    context "when input is a non-recogizable word" do
      it "returns a empty hash with key == zorg and and value == 1" do
        word = "zorg"
        expect(SadPanda.build_term_frequencies(word)).to eql({"zorg" => 1})
      end
    end

    context "when input includes recognizable words" do
      it "returns a non-empty hash" do
        hash = SadPanda.build_term_frequencies("I am happy")
        expect(hash).to_not be_empty
      end
    end

  end

  describe "when 'get_emotion_score' method is called" do
    it 'returns a string' do
      output = SadPanda.get_emotion_score emotions,term_frequencies
      expect(output.class).to eql(String)
    end
  end

  describe "when 'get_polarity_score' method is called" do
    it 'returns a string' do
      output = SadPanda.get_polarity_score polarities,term_frequencies
      expect(output.class).to eql(Fixnum)
    end
  end


  describe "when polarity method is called" do

    it "returns a fixnum" do
      expect(SadPanda.polarity("My cactus collection makes me happy.").class).to eql(Fixnum)
    end

    context "when status_message == 'my lobster collection makes me happy' " do
      it "emotion == 'joy' " do
        status_message = "my lobster collection makes me happy"
        expect(SadPanda.emotion(status_message)).to eql("joy")
      end
    end

    context "when status_message == 'sad' " do
      it "emotion == 'sadness' " do
        status_message = "sad"
        expect(SadPanda.emotion(status_message)).to eql("sadness")
      end
    end

    context "when status_message == 'angry' "  do
      it "emotion == 'anger' " do
        status_message = "angry"
        expect(SadPanda.emotion(status_message)).to eql('anger')
      end
    end

    context "when status_message == 'I am ril afraid of cats, homie' " do
      it "emotion == 'fear' " do
        status_message = "I am ril afraid of cats, homie"
        expect(SadPanda.emotion(status_message)).to eql("fear")
      end
    end

    context "when status == 'I am disgusted' " do
      it "emotion == 'disgust'" do
        status_message =  "I am disgusted"
        expect(SadPanda.emotion(status_message)).to eql('disgust')
      end
    end

    context "when status == 'I am so surprised'" do
      it "emotion == 'surprise'" do
        status_message =  "I am so surprised"
        expect(SadPanda.emotion(status_message)).to eql('surprise')
      end
    end

    context "when status_message == 'blarg' " do
      it "emotion == 'ambiguous' " do
        status_message =  "blarg"
        expect(SadPanda.emotion(status_message)).to eql('ambiguous')
      end
    end

    context "when status_message == '  ' " do
      it "emotion is 'ambiguous'" do
        status_message =  "  "
        expect(SadPanda.emotion(status_message)).to eql('ambiguous')
      end
    end

  end

  describe "when emotion method is called" do

    it "returns a string" do
      status_message="joy"
      expect(SadPanda.emotion(status_message).class).to eql(String)
    end

    context "when status_message == 'I am happy' " do
      it "polarity is greater than zero" do
        status_message = "I am happy"
        expect(SadPanda.polarity(status_message)).to be > 0
      end
    end


    context "when status_message == 'sad' " do
      it "polarity is less than zero" do
        status_message =  "sad"
        expect(SadPanda.polarity(status_message)).to be < 5
      end
    end

    context "when status_message == 'anger' " do
      it "polarity is zero" do
        status_message = "anger"
        expect(SadPanda.polarity(status_message)).to be < 5
      end
    end

    context "when status_message == 'I am terrified' " do
      it "polarity is zero" do
        status_message = "I am fearful"
        expect(SadPanda.polarity(status_message)).to be < 5
      end
    end

    context "when status == 'I am disgusted' " do
      it "has a non-zero polarity value" do
        status_message = "I am disgusted"
        expect(SadPanda.polarity(status_message)).to be < 5
      end
    end

    context "when status == 'This is surprising'" do
      it "has a neutral polarity value" do
        status_message = "This is surprising"
        expect(SadPanda.polarity(status_message)).to eql(5)
      end
    end

    context "when status_message == 'blarg' " do
      it "polarity is zero" do
        status_message = "blarg"
        expect(SadPanda.polarity(status_message)).to eql(5)
      end
    end

    context "when status_message == '  ' " do
      it "polarity is zero" do
        status_message =  "  "
        expect(SadPanda.polarity(status_message)).to eql(5)
      end
    end
  end
end
