require 'active_support/core_ext/array/extract_options'

require 'transformers/boolean'
require 'transformers/method_call'
require 'transformers/missing_option'
require 'transformers/unknown_transformer'
require 'transformers/extensions/hash'

module Transformers
  STANDARD = { :boolean => Transformers::Boolean }.freeze

  def self.custom
    @custom ||= {}
  end

  def self.all
    custom.merge(STANDARD)
  end

  def self.get(transformer)
    case transformer
      when Module, Proc
        transformer
      when Symbol
         all.has_key?(transformer) ? all[transformer] : MethodCall.new(transformer)
      else 
        raise UnknownTransformer.new(transformer)
    end
  end

  def self.register(name, transformer)
    custom[name] = transformer
  end
end