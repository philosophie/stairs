# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stairs/version'

Gem::Specification.new do |spec|
  spec.name          = "stairs"
  spec.version       = Stairs::VERSION
  spec.authors       = ["patbenatar"]
  spec.email         = ["nick@gophilosophie.com"]
  spec.description   = "It's a pain to setup new developers. Stairs is a utility and framework from which to write scripts for faster and easier setup of apps in new development environments. Scripts try to automate as much as possible and provide interactive prompts for everything else."
  spec.summary       = "Setup Ruby apps in development fast and easy."
  spec.homepage      = "http://github.com/patbenatar/stairs"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "guard-rspec", "~> 4.0.3"
  spec.add_development_dependency "rb-fsevent", "~> 0.9.3"
  spec.add_development_dependency "awesome_print", "~> 1.2.0"
  spec.add_development_dependency "fakefs", "~> 0.4.3"
  spec.add_development_dependency "rubocop", "~> 0.20.1"
  spec.add_development_dependency "guard-rubocop", "~> 1.0.0"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "mock_stdio", "~> 0.0.1"

  spec.add_dependency "activesupport", ">= 3.2.0"
  spec.add_dependency "colorize", "~> 0.6.0"
end
