require 'spec_helper'

describe SadPanda::Emotion do
  describe 'initialization' do
    let(:object) { SadPanda::Emotion.new('Initialize this text in sad panda') }

    it 'initializes scores as 0 for all emotions' do
      expect(object.scores).to eq(:anger => 0, :disgust => 0, :joy => 0,
                                  :surprise => 0, :fear => 0, :sadness => 0,
                                  :ambiguous => 0)
    end

    it 'initializes words in an Array' do
      expect(object.words).to eq %w[initialize this text in sad panda]
    end
  end

  describe '#call' do
    context 'when input contains words with emotions' do
      let(:object) { SadPanda::Emotion.new('my lobster collection makes me happy!') }

      it 'returns :joy' do
        expect(object.call).to eq :joy
      end

      it 'scores emotions' do
        object.call
        expect(object.scores).to eq(:anger => 0, :disgust => 0, :joy => 1,
                                    :surprise => 0, :fear => 0, :sadness => 0,
                                    :ambiguous => 0)
      end
    end

    context 'when input contains no words with emotions' do
      let(:object) { SadPanda::Emotion.new(' ') }

      it 'returns :ambiguous' do
        expect(object.call).to eq :ambiguous
      end

      it 'does not scores emotions but ambiguous' do
        object.call
        expect(object.scores).to eq(:anger => 0, :disgust => 0, :joy => 0,
                                    :surprise => 0, :fear => 0, :sadness => 0,
                                    :ambiguous => 1)
      end
    end
  end

  describe 'emotions defined in method_missing' do
    let(:object) { SadPanda::Emotion.new('This is a test affright message for anxiously sadness :)') }

    before do
      object.call
    end

    it 'returns emotion value for fear' do
      expect(object.fear).to eq 2
    end

    it 'returns emotion value for anger' do
      expect(object.anger).to eq 0
    end

    it 'returns emotion value for joy' do
      expect(object.joy).to eq 1
    end

    it 'returns emotion value for disgust' do
      expect(object.disgust).to eq 0
    end

    it 'returns emotion value for surprise' do
      expect(object.surprise).to eq 0
    end

    it 'returns emotion value for sadness' do
      expect(object.sadness).to eq 1
    end

    it 'returns emotion value for ambiguous' do
      expect(object.ambiguous).to eq 0
    end

    it 'raises an exception if the method is not an emotion' do
      expect { object.fake_emotion }.to raise_error(NoMethodError)
    end
  end

  describe '#ambiguous_score' do
    let(:object) { SadPanda::Emotion.new('') }

    context 'when all emotion scores are 0' do
      it 'adds ambiguous to scores as 1' do
        expect(object.scores[:ambiguous]).to eq 0

        object.send(:ambiguous_score)

        expect(object.scores[:ambiguous]).to eq 1
      end
    end

    context 'when some emotion scores are greater than 0' do
      it 'does not adds ambiguous scores' do
        object.scores[:joy] = 1

        object.send(:ambiguous_score)

        expect(object.scores[:ambiguous]).to eq 0
      end
    end
  end

  describe '#score_emotions' do
    let(:object) { SadPanda::Emotion.new('') }

    context 'when word dosent not exist in emotion bank' do
      it 'does nothing and returns nil' do
        expect(object.send(:score_emotions, :joy, 'notjoy', 1)).to eq nil
        expect(object.scores[:joy]).to eq 0
      end
    end

    context 'when word dose exist in emotion bank' do
      it 'updates scores with frequency' do
        expect(object.send(:score_emotions, :joy, 'happy', 1)).to eq 1
        expect(object.scores[:joy]).to eq 1
      end
    end
  end

  describe '#set_emotions' do
    let(:object) { SadPanda::Emotion.new('') }

    context 'when word dosent not exist in any emotion bank' do
      it 'does not add any score' do
        object.send(:set_emotions, 'notaword', 1)
        expect(object.scores).to eq(:anger => 0, :disgust => 0,:joy => 0,
                                    :surprise => 0, :fear => 0, :sadness => 0,
                                    :ambiguous => 0)
      end
    end

    context 'when word dose exist in an emotion bank' do
      it 'add frequency to score of the emotion' do
        object.send(:set_emotions, 'happy', 1)
        expect(object.scores).to eq(:anger => 0, :disgust => 0,:joy => 1,
                                    :surprise => 0, :fear => 0, :sadness => 0,
                                    :ambiguous => 0)
      end
    end
  end

  describe '#score_words' do
    let(:object) { SadPanda::Emotion.new('') }

    context 'when words dosent not exist in any emotion bank' do
      it 'does not add any score but ambiguous' do
        object.send(:score_words, { 'notword' => 1, 'foobar' => 2})
        expect(object.scores).to eq(:anger => 0, :disgust => 0,:joy => 0,
                                    :surprise => 0, :fear => 0, :sadness => 0,
                                    :ambiguous => 1)
      end
    end

    context 'when word dose exist in an emotion bank' do
      it 'add frequency to score of the emotion' do
        object.send(:score_words, { 'happy' => 1, 'sad' => 2})
        expect(object.scores).to eq(:anger => 0, :disgust => 0,:joy => 1,
                                    :surprise => 0, :fear => 0, :sadness => 2,
                                    :ambiguous => 0)
      end
    end
  end  
end
