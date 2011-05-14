require 'transformers'
require 'transformers/rails'
require 'rspec/transformers'

RSpec.configure do |config|
  config.mock_with :mocha
end