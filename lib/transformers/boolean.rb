module Transformers
  module Boolean
    TRUE_VALUES = ['true', true].freeze

    def self.call(value)
      TRUE_VALUES.include?(value)
    end
  end
end