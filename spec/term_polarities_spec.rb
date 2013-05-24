require 'spec_helper'

describe TermPolarities do
	describe "when TermPolarities module is called" do

		let(:output) {TermPolarities.get_term_polarities}

		it "returns a hash" do
			expect(output.class).to eql(Hash)
		end

		it "is non empty" do
			expect(output).to_not be_empty
		end
	end
end