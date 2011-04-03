require File.expand_path(File.join(File.dirname(__FILE__), 'support', 'convert_to_matcher'))

require 'transformers'

RSpec.configure do |config|
  config.mock_with :mocha
end