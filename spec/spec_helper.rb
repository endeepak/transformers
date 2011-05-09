require 'transformers'
require 'transformers/rails'

require File.expand_path(File.join(File.dirname(__FILE__), 'support', 'convert_to_matcher'))

RSpec.configure do |config|
  config.mock_with :mocha
end