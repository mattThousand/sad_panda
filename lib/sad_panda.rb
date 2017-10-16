require 'sad_panda/bank/emotions'
require 'sad_panda/bank/polarities'
require 'sad_panda/bank/stopwords'
require 'sad_panda/emotion'
require 'sad_panda/polarity'
require 'sad_panda/helpers'
require 'lingua/stemmer'

# SadPanda main module
module SadPanda
  # this method returns the best-fit emotion for the status message
  def self.emotion(text)
    # get the emotion for which the emotion score value is highest
    SadPanda::Emotion.new(text).call
  end

  # this method returns the polarity value for the status message
  # (normalized by the number of 'polar' words that the status
  # message contains)
  def self.polarity(text)
    # get the polarity for which the polarity score value is highest
    SadPanda::Polarity.new(text).call
  end
end
