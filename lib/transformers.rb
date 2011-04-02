module Transformers
  module Hash
    def transform(&block)
      self.instance_eval(&block)
    end

    def convert(key, options = {})
      new_key = options[:as] || key
      converter = options[:to]
      value = self.delete(key)
      new_value = converter ? converter.call(value) : value
      self[new_key] = new_value
    end
  end
end

Hash.send(:include, Transformers::Hash)