# SadPanda

sad_panda is a gem featuring tools for sentiment analysis of natural language: positivity/negativity and emotion classification.

Emotion Range: "anger", "disgust", "joy", "surprise", "fear", "sadness"

Polarity Range: -2 to 2

## Installation

Add this line to your application's Gemfile:

    gem 'sad_panda'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sad_panda

## Usage

		require 'sad_panda'

		my_message = SadPanda::StatusMessage.new "my lobster collection makes me happy!"

		my_message.emotion
		=> "joy"

		my_message.polarity
		=> 0.25

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
