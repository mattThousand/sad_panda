require 'spec_helper'

describe SadPanda do
  describe '#emotion' do
    it 'returns a Symbol result' do
      expect(SadPanda.emotion('panda emotion respose')).to be_a Symbol
    end

    context 'joy' do
      it 'returns :joy for a happy text' do
        expect(SadPanda.emotion('my lobster collection makes me happy!')).to eq :joy
      end

      it 'returns :joy for a happy emoji' do
        expect(SadPanda.emotion('my lobster collection makes me :)')).to eq :joy
      end
    end

    context 'anger' do
      it 'returns :anger for an angry text' do
        expect(SadPanda.emotion('Can the JS devils focus on one framewors than having 100')).to eq :anger
      end
    end

    context 'fear' do
      it 'returns :fear for an fearedful text' do
        expect(SadPanda.emotion('I am ril afraid of cats, homie')).to eq :fear
      end
    end

    context 'disgust' do
      it 'returns :disgust for an text with disgust' do
        expect(SadPanda.emotion('I am disgusted')).to eq :disgust
      end
    end

    context 'surprise' do
      it 'returns :surprise for an surprising text' do
        expect(SadPanda.emotion('ActionCable mystifies me')).to eq :surprise
      end
    end

    context 'ambiguous' do
      it 'returns :ambiguous for a neutral text' do
        expect(SadPanda.emotion('Python is ok')).to eq :ambiguous
      end

      it 'returns :ambiguous for an empty string' do
        expect(SadPanda.emotion('  ')).to be :ambiguous
      end
    end

    context 'sadness' do
      it 'returns :sadness for a sad text' do
        expect(SadPanda.emotion('Slow tests make me sad')).to eq :sadness
      end

      it 'returns :anger for an sad emoji' do
        expect(SadPanda.emotion('Angular, React & Vue. Now what? :(')).to eq :sadness
      end
    end
  end

  describe '#polarity' do
    let(:polarity) { SadPanda.polarity('I love cactuses!') }

    it 'returns a Float value polarity' do
      expect(polarity).to be_a Float
    end

    it 'returns 10.0' do
      expect(polarity).to eq 10.0
    end

    it 'returns 8.0 for happy emoji' do
      expect(SadPanda.polarity(':)')).to eq 8.0
    end

    it 'returns 8.0 for sad emoji' do
      expect(SadPanda.polarity(':(')).to eq 2.0
    end

    it 'returns 5.0 for happy & sademoji' do
      expect(SadPanda.polarity(':) :(')).to eq 5.0
    end

    it 'returns 5.0 for empty string' do
      expect(SadPanda.polarity(' ')).to eq 5.0
    end

    it 'returns 5.0 for a neutral' do
      expect(SadPanda.polarity('This is surprising')).to be 5.0
    end
  end

  # New Stuff
  # let(:emotion) { SadPanda::Emotion.new('My cactus collection makes me happy') }

  # let(:polarities) { SadPanda::Polarities }
  # let(:emotion_score) { {} }
  # let(:polarity_scores) { [] }
  # let(:polarity_hash) { SadPanda::Polarities }

  # # New Stuff
  # describe 'Emotion class' do
  #   let(:object) { SadPanda::Emotion.new('This is a test affright message for anxiously sadness :)') }

  #   it 'returns fear' do
  #     expect(object.call).to be :fear
  #   end

  #   it 'return emotion values' do
  #     object.call
  #     expect(object.fear).to be 2
  #     expect(object.anger).to be 0
  #     expect(object.joy).to be 1
  #     expect(object.disgust).to be 0
  #     expect(object.surprise).to be 0
  #     expect(object.sadness).to be 1
  #     expect(object.ambiguous).to be 0

  #     expect { object.fake_emotion }.to raise_error(NoMethodError)
  #   end
  # end

  # describe 'Polarity class' do
  #   let(:object) { SadPanda::Polarity.new("I love cactuses!") }

  #   it 'returns fear' do
  #     expect(object.call).to be 10.0
  #   end
  # end

  # describe '#emotions' do
  #   it 'returns emothions with' do
  #     expect(SadPanda.emotion('This is a test affright message for anxiously sadness :)')).to be :fear
  #   end
  # end

  # context 'methods' do
  #   describe '#happy_emoticon' do
  #     context 'when true' do
  #       it 'returns true' do
  #         message = ':)'
  #         expect(SadPanda.happy_emoticon(message)).to be true
  #       end
  #     end

  #     context 'when false' do
  #       it 'returns true' do
  #         message = 'stuff'
  #         expect(SadPanda.happy_emoticon(message)).to be false
  #       end
  #     end
  #   end

  #   describe '#sad_emoticon' do
  #     context 'when true' do
  #       it 'returns true' do
  #         message = ':('
  #         expect(SadPanda.sad_emoticon(message)).to be true
  #       end
  #     end

  #     context 'when false' do
  #       it 'returns true' do
  #         message = 'stuff'
  #         expect(SadPanda.sad_emoticon(message)).to be false
  #       end
  #     end
  #   end

    # describe '#set_emotions' do
    #   it 'modifies the emotions_score array' do
    #     term_frequencies.each do |key, value|
    #       SadPanda.set_emotions(emotions, emotion_score, key, value)
    #     end

    #     expect((emotion_score[:joy])).to eql(1)
    #   end
    # end

    # describe '#set_polarities' do
    #   it 'modifies the polarity_scores array' do
    #     term_frequencies = {'sad' => 1}
    #     term_frequencies.each do |key, value|
    #       SadPanda.set_polarities(key, value, polarity_hash, polarity_scores)
    #     end
    #     expect(polarity_scores).to eql([0.0])
    #   end
    # end

    # describe '#store_emotions' do
    #   it 'stores emotions in emotion_score hash' do
    #     emotions = {"joy" => "zorg" }
    #     key,value = "zorg", 1

    #     emotions.keys.each do |k|
    #       SadPanda.store_emotions(emotions, emotion_score, k, key, value)
    #     end
    #     expect(emotion_score["joy"]).to eql(1)
    #   end
    # end

    # describe '#store_polarities' do
    #   context 'word in polarity_hash' do
    #     it 'adds a polarity to polarity_scores' do
    #       SadPanda.store_polarities('sad', :sad, polarity_hash, polarity_scores)
    #       expect(polarity_scores).to eql([0.0])
    #     end
    #   end

    #   context 'word not in polarity_hash' do
    #     it 'does not add a polarity to polarity_scores' do
    #       term = 'sad'
    #       word = 'cactus'
    #       SadPanda.store_polarities(term, word, polarity_hash, polarity_scores)
    #       expect(polarity_scores).to eql([])
    #     end
    #   end
    # end

    # describe '#check_emoticon_for_emotion' do
    #   context 'contains happy emoticon' do
    #     it 'returns :joy' do
    #       message = ':)'
    #       output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
    #       expect(output).to be :joy
    #     end
    #   end

    #   context 'contains sad emoticon' do
    #     it 'returns :sadness' do
    #       message = ':('
    #       output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
    #       expect(output).to be :sadness
    #     end
    #   end

    #   context 'contains both a happy and a sad emoticon' do
    #     it 'returns :ambiguous' do
    #       message = ':( :)'
    #       output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
    #       expect(output).to be :ambiguous
    #     end
    #   end

    #   context 'contains no emoticons and emotion_score is not empty' do
    #     it 'returns joy' do
    #       message = 'no emoticons in hur'
    #       emotion_score = { joy: 1 }
    #       output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
    #       expect(output).to be :joy
    #     end
    #   end

    #   context 'contains no emoticons and emotion_score is  empty' do
    #     it 'returns :ambiguous' do
    #       message = 'no emoticons in hur'
    #       output = SadPanda.check_emoticon_for_emotion(emotion_score, message)
    #       expect(output).to be :ambiguous
    #     end
    #   end
    # end

    # describe '#check_emoticon_for_polarity' do
    #   context 'contains happy emoticon' do
    #     it 'returns 8' do
    #       message = ':)'
    #       polarity_scores = [2.0,3.0]
    #       output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
    #       expect(output).to eql(8)
    #     end
    #   end

    #   context 'contains sad emoticon' do
    #     it 'returns 2' do
    #       message = ':('
    #       polarity_scores = [2.0,3.0]
    #       output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
    #       expect(output).to eql(2)
    #     end
    #   end

    #   context 'contains both a happy and a sad emoticon' do
    #     it 'returns 5' do
    #       message = ':( :)'
    #       polarity_scores = [2.0, 3.0]
    #       output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
    #       expect(output).to eql(5)
    #     end
    #   end

    #   context 'contains no emoticons and polarity_scores is empty' do
    #     it 'returns joy' do
    #       message = "no emoticons in hur"
    #       polarity_scores = []
    #       output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
    #       expect(output).to eql(5)
    #     end
    #   end

    #   context 'contains no emoticons and emotion_score is not empty' do
    #     it 'returns joy' do
    #       message = "no emoticons in hur"
    #       polarity_scores = [8.0]
    #       output = SadPanda.check_emoticon_for_polarity(polarity_scores, message)
    #       expect(output).to eql(8.0)
    #     end
    #   end
    # end
  # end

  # describe 'when term_frequencies method is called' do
  #   context 'when input is a non-recogizable word' do
  #     it 'returns a empty hash with key == zorg and and value == 1' do
  #       word = 'zorg'
  #       obj = SadPanda::Emotion.new(word)
  #       obj.call

  #       expect(obj.send(:word_frequencies)).to eql({ "zorg" => 1 })
  #     end
  #   end

  #   context 'when input includes recognizable words' do
  #     it 'returns a non-empty hash' do
  #       word = 'I am happy'
  #       obj = SadPanda::Emotion.new(word)
  #       obj.call

  #       expect(obj.send(:word_frequencies)).to_not be_empty
  #     end
  #   end
  # end

  # describe 'when #emotion_score method is called' do
  #   it 'returns a symbol of the emotion detected' do
  #     message = 'this is a message!'
  #     output = SadPanda.emotion_score(message, emotions, term_frequencies)
  #     expect(output).to be_a Symbol
  #   end
  # end

  # describe 'when emotion method is called' do
  #   context 'when status_message is I am happy' do
  #     it 'polarity is greater than zero' do
  #       status_message = 'I am happy'
  #       expect(SadPanda.polarity(status_message)).to be > 0
  #     end
  #   end

  #   context 'when status_message == sad' do
  #     it 'polarity is less than zero' do
  #       status_message = 'sad'
  #       expect(SadPanda.polarity(status_message)).to be < 5
  #     end
  #   end

  #   context 'when status_message is anger' do
  #     it 'polarity is zero' do
  #       status_message = 'anger'
  #       expect(SadPanda.polarity(status_message)).to be < 5
  #     end
  #   end

  #   context 'when status_message is I am terrified' do
  #     it 'polarity is zero' do
  #       status_message = 'I am fearful'
  #       expect(SadPanda.polarity(status_message)).to be < 5
  #     end
  #   end

  #   context 'when status == I am disgusted' do
  #     it 'has a non-zero polarity value' do
  #       status_message = 'I am disgusted'
  #       expect(SadPanda.polarity(status_message)).to be < 5
  #     end
  #   end

  # end
end
