module Transformers
  module Extensions
    module Hash
      def transform(key = nil, &block)
        target = key.nil? ? self : self[key]
        if target
          raise TypeError.new("Can't apply transformations on #{target.inspect}. Expected a Hash") unless target.is_a?(Hash)
          target.instance_eval(&block)
        end
      end

      def convert(*keys)
        options = keys.extract_options!
        new_key = options[:as] || keys.first
        converter = options[:to]
        values = keys.collect { |key| delete(key) }
        new_value = converter ? Transformers.get(converter).call(*values) : (values.length == 1 ? values.first : values)
        self[new_key] = new_value
      end

      def rename(key, options = {})
        new_key = options[:to]
        raise MissingOption.new(:to) if new_key.nil?
        self[new_key] = self.delete(key)
      end
    end
  end
end

Hash.send(:include, Transformers::Extensions::Hash)