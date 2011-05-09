require "action_controller/railtie"

module Transformers
  module Extensions
    module ActionController
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def transform_params(*args, &block)
          options = args.extract_options!
          before_filter(options) { params.transform(args.first, &block) }
        end
      end
    end
  end
end

ActionController::Base.send(:include, Transformers::Extensions::ActionController)