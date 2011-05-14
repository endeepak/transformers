Transformers [![Build Status](http://travis-ci.org/endeepak/transformers.png)](http://travis-ci.org/endeepak/transformers)
============

Transformers is an extension to hash to allow various transformations using simple DSL. It also has optional rails extension to dry up frequently applied transformations on controller params.

Install
=======

        gem install transformers

OR Add dependency in _Gemfile_ for projects using bundler

        gem 'transformers'

Available Transformations
=========================

* Convert values

        hash = {:foo => 'bar'}

        hash.convert :eric, :to => lambda { |value| value.upcase }

      OR use short hand notation to call a method on the value

        hash.convert :foo, :to => :upcase

* Combine keys

        hash.convert :begin, :end, :as => :range

* Rename keys

        hash.rename :foo, :to => :bar

      OR

        hash.convert :foo, :as => :bar

* Alias key

        hash.copy :foo, :to => :bar

* Convert and combine

        hash.convert :first_name, :last_name, :as => :name, :to => lambda { |first_name, last_name| first_name + ' '+ last_name }

* Conversion using type converters

        hash = {:foo => 'true'}

        hash.convert :foo, :to => :boolean         #built-in

* Using Custom converters : You can pass a lambda or define a module or an object which has a call method. This method will receive values for given keys and should return the converted value.

        module Transformers::Name
          def self.call(first_name, last_name)
            return first_name + ' '+ last_name
          end
        end

  Register the converter

        Transformers.register(:name, Transformers::Name)

  Usage

        hash.convert :first_name, :last_name, :as => :name, :to => :name

* Use them together in a transform block

        hash.transform do
          delete :unwanted
          rename :foo, :to => :bar
          convert :first_name, :last_name, :as => :name, :to => :name
        end


Rails Extensions
================

To Include rails extensions add the below line in a config/initializer/transformers.rb. You can register the custom transformers in the same file.

        require 'transformers/rails'

This adds _transform\_params_ extension to action controller. You can define the transformations for any action as,

        transform_params :search, :only => :index do
          convert :first_name, :last_name, :as => :name, :to => :name
        end

This will add a before\_filter in the controller to apply transformations on params[:search]. If the first argument is omitted, the transformations will be applied directly on the params. The options for transform\_params are same as before\_filter options.

Rspec Matcher
=============
This gem has a rspec matcher for testing the custom converters. To use this, add the below line in the _spec\_helper_

        require 'rspec/transformers'

The converter spec can be written as

        describe Transformers::Boolean do
          it { should convert('true').to(true)}
          it { should convert('false').to(false)}
        end




