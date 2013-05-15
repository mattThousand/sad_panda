# SadPanda

sad_panda is a gem currently-in-progress with tools for sentiment analysis ultimately including bayesian classifiers for positivity/negativity and emotion classification.

## Installation

Add this line to your application's Gemfile:

    gem 'sad_panda'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sad_panda

## Usage

require 'sad_panda'

my_message = SadPanda::StatusMessage.new "I love sad_panda, and I will love it even more when it is finished."

my_message.emotion     
=> "joy"

my_message.polarity     
=> 2

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
