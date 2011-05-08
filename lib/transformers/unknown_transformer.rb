module Transformers
  class UnknownTransformer < Exception
    def initialize(transformer)
      super("The #{transformer.inspect} transformer is not supported")
    end
  end
end