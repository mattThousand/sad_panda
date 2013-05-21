# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sad_panda/version'

Gem::Specification.new do |spec|
  spec.name          = "sad_panda"
  spec.version       = SadPanda::VERSION
  spec.authors       = ["Matt Buckley"]
  spec.email         = ["matt.d.buckley1212@gmail.com"]
  spec.description   = %q{sad_panda is a gem featuring tools for sentiment analysis of natural language: positivity/negativity and emotion classification.}
  spec.summary       = %q{sad_panda is a gem featuring tools for sentiment analysis of natural language: positivity/negativity and emotion classification.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "ruby-stemmer"
  spec.add_runtime_dependency "lingua/stemmer"
  spec.add_development_dependency "rspec"
end
