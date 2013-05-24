require 'spec_helper'

describe EmotionBank do

		let(:output) {EmotionBank.get_term_emotions}

		describe "when EmotionBank module is called" do
			it 'returns a hash' do
				expect(output.class).to eql(Hash)
			end

			it "is non-empty" do
				expect(output).to_not be_empty
			end
		end
end
