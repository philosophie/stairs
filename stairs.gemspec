# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stairs/version'

Gem::Specification.new do |spec|
  spec.name          = "stairs"
  spec.version       = Stairs::VERSION
  spec.authors       = ["patbenatar"]
  spec.email         = ["nick@gophilosophie.com"]
  spec.description   = "A DSL and collection of plugins for easy setup of projects on new development environments."
  spec.summary       = "A DSL and collection of plugins for easy setup of projects on new development environments."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "highline", "~> 1.6.20"
  spec.add_dependency "activesupport", "> 3.2.0"
end
