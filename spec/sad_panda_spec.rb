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
      expect(SadPanda.polarity('This is surprising')).to eq 5.0
    end
  end
end
