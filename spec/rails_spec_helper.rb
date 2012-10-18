require 'rails/all'

class Transformers::Application < Rails::Application
end

require 'rspec/rails'

Transformers::Application.routes.draw do
  match ':controller(/:action(/:id(.:format)))'
end