module Transformers
  class MethodCall
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def call(value)
      value.send(self.name)
    end

    def ==(other)
      self.name.to_s == other.name.to_s
    end
  end
end
