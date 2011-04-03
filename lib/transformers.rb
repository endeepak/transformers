require 'transformers/boolean'
require 'transformers/method_call'
require 'transformers/extensions/hash'

module Transformers
  ALL = { :boolean => Transformers::Boolean }

  def self.get(converter)
    case converter
      when Module, Proc: converter
      else ALL.has_key?(converter) ? ALL[converter] : MethodCall.new(converter)
    end
  end
end

