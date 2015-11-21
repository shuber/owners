if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  require "simplecov"
  SimpleCov.start { add_filter("/vendor/bundle/") }
end

require File.expand_path("../../lib/owners", __FILE__)

RSpec.configure do |config|
  config.filter_run :focus
  config.raise_errors_for_deprecations!
  config.run_all_when_everything_filtered = true
end
