require 'spec_helper'

describe SadPanda  do
  let(:emotions) { SadPanda::EmotionBank::Emotions }
  let(:polarities) { SadPanda::Polarities }
  let(:term_frequencies) { SadPanda.term_frequencies('My cactus collection makes me happy.') }
  let(:emotion_score) { {} }
  let(:polarity_scores) { [] }
  let(:polarity_hash) { SadPanda::Polarities }

  describe '#emotions' do
    it 'returns emothions with' do
      expect(SadPanda.analyse('This is a test affright message for anxiously sadness :)')).to be :fear
    end
  end

  context 'methods' do
    describe '#happy_emoticon' do
      context 'when true' do
        it 'returns true' do
          message = ":)"
          expect(SadPanda.happy_emoticon(message)).to be true
        end
      end

      context 'when false' do
        it 'returns true' do
          message = "stuff"
          expect(SadPanda.happy_emoticon(message)).to be false
        end
      end
    end

    describe '#sad_emoticon' do
      context 'when true' do
        it 'returns true' do
          message = ":("
          expect(SadPanda.sad_emoticon(message)).to be true
        end
      end

      context 'when false' do
        it 'returns true' do
          message = "stuff"
          expect(SadPanda.sad_emoticon(message)).to be false
        end
      end
    end

    describe '#words_from_message_text' do
      it 'removes urls and other gross stuff from tweet' do
        message = "lobster hickory http://www.boston.com/business #Rails"

        words = SadPanda.words_from_message_text(message)

        expect(words).to eql(["lobster", "hickory", "rails"])
      end
    end

    describe '#set_emotions' do
      it 'modifies the emotions_score array' do
        term_frequencies.each do |key, value|
          SadPanda.set_emotions(emotions, emotion_score, key, value)
        end
        expect((emotion_score[:joy])).to eql(1)
      end
    end

    describe '#set_polarities' do
      it 'modifies the polarity_scores array' do
        term_frequencies = {'sad' => 1}
        term_frequencies.each do |key, value|
          SadPanda.set_polarities(key, value, polarity_hash, polarity_scores)
        end
        expect(polarity_scores).to eql([0.0])
      end
    end

    describe '#store_emotions' do
      it 'stores emotions in emotion_score hash' do
        emotions = {"joy" => "zorg" }
        key,value = "zorg", 1

        emotions.keys.each do |k|
          SadPanda.store_emotions(emotions, emotion_score, k, key, value)
        end
        expect(emotion_score["joy"]).to eql(1)
      end
    end

    describe '#store_polarities' do
      context 'word in polarity_hash' do
        it 'adds a polarity to polarity_scores' do
          SadPanda.store_polarities('sad', :sad, polarity_hash, polarity_scores)
          expect(polarity_scores).to eql([0.0])
        end
      end

      context 'word not in polarity_hash' do
        it 'does not add a polarity to polarity_scores' do
          term = 'sad'
          word = 'cactus'
          SadPanda.store_polarities(term, word, polarity_hash, polarity_scores)
          expect(polarity_scores).to eql([])
        end
      end
    end

    describe '#create_term_frequencies' do
      it 'populates a word-stem frequency hash' do
        words = %w(yo stuff)
        word_stems = SadPanda.word_stems(words)
        term_frequencies = SadPanda.create_term_frequencies(word_stems)

        expect(term_frequencies).to eql({"yo"=>1, "stuff"=>1})
      end

    end

    describe '#check_emoticon_for_emotion' do
      context 'contains happy emoticon' do
        it 'returns :joy' do
          message = ':)'
          output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
          expect(output).to be :joy
        end
      end

      context 'contains sad emoticon' do
        it 'returns :sadness' do
          message = ':('
          output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
          expect(output).to be :sadness
        end
      end

      context 'contains both a happy and a sad emoticon' do
        it 'returns :ambiguous' do
          message = ':( :)'
          output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
          expect(output).to be :ambiguous
        end
      end

      context 'contains no emoticons and emotion_score is not empty' do
        it 'returns joy' do
          message = 'no emoticons in hur'
          emotion_score = { joy: 1 }
          output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
          expect(output).to be :joy
        end
      end

      context 'contains no emoticons and emotion_score is  empty' do
        it 'returns :ambiguous' do
          message = 'no emoticons in hur'
          output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
          expect(output).to be :ambiguous
        end
      end
    end

    describe '#check_emoticon_for_polarity' do
      context 'contains happy emoticon' do
        it 'returns 8' do
          message = ':)'
          polarity_scores = [2.0,3.0]
          output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
          expect(output).to eql(8)
        end
      end

      context 'contains sad emoticon' do
        it 'returns 2' do
          message = ':('
          polarity_scores = [2.0,3.0]
          output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
          expect(output).to eql(2)
        end
      end

      context 'contains both a happy and a sad emoticon' do
        it 'returns 5' do
          message = ':( :)'
          polarity_scores = [2.0, 3.0]
          output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
          expect(output).to eql(5)
        end
      end

      context 'contains no emoticons and polarity_scores is empty' do
        it 'returns joy' do
          message = "no emoticons in hur"
          polarity_scores = []
          output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
          expect(output).to eql(5)
        end
      end

      context 'contains no emoticons and emotion_score is not empty' do
        it 'returns joy' do
          message = "no emoticons in hur"
          polarity_scores = [8.0]
          output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
          expect(output).to eql(8.0)
        end
      end
    end
  end

  describe 'when term_frequencies method is called' do
    context 'when status_message is an empty string' do
      it 'returns an empty hash' do
        empty_message = "   "
        expect(SadPanda.term_frequencies(empty_message)).to be_empty
      end
    end

    context 'when input is a non-recogizable word' do
      it 'returns a empty hash with key == zorg and and value == 1' do
        word = "zorg"
        expect(SadPanda.term_frequencies(word)).to eql({"zorg" => 1})
      end
    end

    context 'when input includes recognizable words' do
      it 'returns a non-empty hash' do
        hash = SadPanda.term_frequencies("I am happy")
        expect(hash).to_not be_empty
      end
    end
  end

  describe 'when #emotion_score method is called' do
    it 'returns a symbol of the emotion detected' do
      message = 'this is a message!'
      output = SadPanda.emotion_score(message, emotions, term_frequencies)
      expect(output).to be_a Symbol
    end
  end

  describe 'when #polarity_score method is called' do
    it 'returns a string' do
      message = "this is another message!"
      output = SadPanda.polarity_score(message, polarities, term_frequencies)
      expect(output.class).to eql(Fixnum)
    end
  end

  describe 'when polarity method is called' do
    it 'returns a fixnum' do
      expect(SadPanda.polarity("My cactus collection makes me happy.").class).to eql(Fixnum)
    end

    context 'when status_message is my lobster collection makes me happy' do
      it 'returns :joy'  do
        status_message = 'my lobster collection makes me happy'
        expect(SadPanda.emotion(status_message)).to be :joy
      end
    end

    context 'when status_message is sad' do
      it 'returns :sadness' do
        status_message = 'sad'
        expect(SadPanda.emotion(status_message)).to be :sadness
      end
    end

    context 'when status_message is angry' do
      it 'returns :anger' do
        status_message = 'angry'
        expect(SadPanda.emotion(status_message)).to be :anger
      end
    end

    context 'when status_message is I am ril afraid of cats, homie' do
      it 'returns :fear' do
        status_message = 'I am ril afraid of cats, homie'
        expect(SadPanda.emotion(status_message)).to be :fear
      end
    end

    context 'when status_message is I am disgusted' do
      it 'returns :disgust' do
        status_message = 'I am disgusted'
        expect(SadPanda.emotion(status_message)).to be :disgust
      end
    end

    context 'when status is I am so surprised' do
      it 'returns :surprise' do
        status_message = 'I am so surprised'
        expect(SadPanda.emotion(status_message)).to be :surprise
      end
    end

    context 'when status_message is blarg' do
      it 'returns ambiguous' do
        status_message = 'blarg'
        expect(SadPanda.emotion(status_message)).to be :ambiguous
      end
    end

    context 'when status_message is an empty string' do
      it 'returns :ambiguous' do
        status_message = '  '
        expect(SadPanda.emotion(status_message)).to be :ambiguous
      end
    end
  end

  describe 'when emotion method is called' do
    it 'returns a symbol' do
      status_message = 'joy'
      expect(SadPanda.emotion(status_message)).to be_a Symbol
    end

    context 'when status_message is I am happy' do
      it 'polarity is greater than zero' do
        status_message = 'I am happy'
        expect(SadPanda.polarity(status_message)).to be > 0
      end
    end

    context 'when status_message == sad' do
      it 'polarity is less than zero' do
        status_message =  'sad'
        expect(SadPanda.polarity(status_message)).to be < 5
      end
    end

    context 'when status_message is anger' do
      it 'polarity is zero' do
        status_message = 'anger'
        expect(SadPanda.polarity(status_message)).to be < 5
      end
    end

    context 'when status_message is I am terrified' do
      it 'polarity is zero' do
        status_message = 'I am fearful'
        expect(SadPanda.polarity(status_message)).to be < 5
      end
    end

    context 'when status == I am disgusted' do
      it 'has a non-zero polarity value' do
        status_message = 'I am disgusted'
        expect(SadPanda.polarity(status_message)).to be < 5
      end
    end

    context 'when status is This is surprising' do
      it 'has a neutral polarity value' do
        status_message = 'This is surprising'
        expect(SadPanda.polarity(status_message)).to eql(5)
      end
    end

    context 'when status_message == blarg' do
      it 'polarity is zero' do
        status_message = 'blarg'
        expect(SadPanda.polarity(status_message)).to eql(5)
      end
    end

    context 'when status_message == empty string' do
      it 'polarity is zero' do
        status_message =  '  '
        expect(SadPanda.polarity(status_message)).to eql(5)
      end
    end
  end
end
