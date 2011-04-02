require 'active_support/core_ext/array/extract_options'

module Transformers
  module Hash
    def transform(&block)
      self.instance_eval(&block)
    end

    def convert(*keys)
      options = keys.extract_options!
      new_key = options[:as] || keys.first
      converter = options[:to]
      values = keys.collect { |key| delete(key) }
      new_value = converter ? converter.call(*values) : (values.length == 1 ? values.first : values)
      self[new_key] = new_value
    end
  end
end

Hash.send(:include, Transformers::Hash)