# SadPanda

sad_panda is a gem featuring tools for sentiment analysis of natural language: positivity/negativity and emotion classification.

Emotion Range: "anger", "disgust", "joy", "surprise", "fear", "sadness"

Polarity Range: 0 to 10

## Installation

Add this line to your application's Gemfile:

    gem 'sad_panda'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sad_panda

## Usage

		require 'sad_panda'

		SadPanda.emotion('my lobster collection makes me happy!')
		=> :joy

		SadPanda.polarity('I love cactuses!')
		=> 10.0

		sad_panda = SadPanda::Emotion.new('my lobster collection makes me happy!')
		sad_panda.call
		sad_panda.scores = {:anger=>0, :disgust=>0, :joy=>1, :surprise=>0, 
		:fear=>0, :sadness=>0, :ambiguous=>0}

		sad_panda.joy => 1
		sad_panda.fear => 0
		# same for all the other emotions
		
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
