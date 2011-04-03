require 'active_support/core_ext/array/extract_options'

module Transformers
  module Extensions
    module Hash
      def transform(&block)
        self.instance_eval(&block)
      end

      def convert(*keys)
        options = keys.extract_options!
        new_key = options[:as] || keys.first
        converter = options[:to]
        values = keys.collect { |key| delete(key) }
        new_value = converter ? Transformers.get(converter).call(*values) : (values.length == 1 ? values.first : values)
        self[new_key] = new_value
      end
    end
  end
end

Hash.send(:include, Transformers::Extensions::Hash)