require 'bundler'
Bundler.require

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'stairs'

require 'mock_stdio'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.include MockStdio

  config.before(:all, &:silence_output)
  config.after(:all, &:enable_output)
  config.after(:each) { Stairs.reset_configuration! }
end
