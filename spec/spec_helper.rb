require 'transformers'
require 'transformers/rails'
require 'rspec/transformers'

require 'rails_spec_helper'

RSpec.configure do |config|
  config.mock_with :mocha
end