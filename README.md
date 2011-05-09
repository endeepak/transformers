Transformers [![Build Status](http://travis-ci.org/endeepak/transformers.png)](http://travis-ci.org/endeepak/transformers)
============

Transformers is an extension to hash to allow various transformations using simple DSL. It also has optional rails extension which can used to dry up frequently used transformations applied on action params.

Install
=======

[not yet released]

Usage
=====

        gem install transformers

OR Add dependency in gem file for projects using bundler

        gem transformers

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

* Using Custom converters

  Define a module, object or lambda which responds to call method and returns converted value.

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






