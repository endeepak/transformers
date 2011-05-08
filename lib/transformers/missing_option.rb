module Transformers
  class MissingOption < Exception
    def initialize(*options)
      super("Missing options : #{options.collect(&:inspect).join(', ')}")
    end
  end
end