## spec/rails_helper.rb
require 'simplecov'
SimpleCov.start
SimpleCov.command_name :rails_helper
SimpleCov.coverage_dir 'coverage'

RSpec.configure do |config|
  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end
end