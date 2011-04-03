module Transformers
  TRUE_VALUES = ['true', true].freeze

  class Boolean
    def self.call(value)
      TRUE_VALUES.include?(value)
    end
  end
end