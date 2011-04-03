require 'spec_helper'

describe Transformers do
  describe "transform" do
    it "should execute the transformations in the context of hash" do
      hash = {:key => 'value'}

      hash.transform { delete :key }

      hash.has_key?(:key).should_not be_true
    end
  end

  describe "convert" do
    describe "as" do
      context "for single key" do
        it "should rename the key" do
          hash = {:stan => 'marsh'}

          hash.transform { convert :stan, :as => :eric }

          hash.has_key?(:stan).should_not be_true
          hash.has_key?(:eric).should be_true
          hash[:eric].should == 'marsh'
        end
      end

      context "for multiple keys" do
        it "should combine the keys to single key" do
          hash = {:begin => 12, :end => 22}

          hash.transform { convert :begin, :end, :as => :range }

          hash.has_key?(:begin).should_not be_true
          hash.has_key?(:end).should_not be_true
          hash.has_key?(:range).should be_true
          hash[:range].should == [12, 22]
        end
      end
    end

    describe "to" do
      it "should accept a object/lambda/module/class which responds to call method" do
        module UpCase
          def self.call(value)
            return value.upcase
          end
        end
        hash = {:eric => 'cartman'}

        hash.transform { convert :eric, :to => UpCase }

        hash[:eric].should == 'CARTMAN'
      end

      context "for single key" do
        it "should apply conversion logic as per converter" do
          hash = {:eric => 'cartman'}

          hash.transform do
            convert :eric, :to => lambda { |value| value.upcase }
          end

          hash[:eric].should == 'CARTMAN'
        end
      end

      context "for multiple keys" do
        it "should apply conversion logic as per converter" do
          hash = {:first_name => 'cartman', :last_name => 'genius' }

          hash.transform do
            convert :first_name, :last_name, :as => :name, :to => lambda { |first_name, last_name| first_name + ' '+ last_name }
          end

          hash[:name].should == 'cartman genius'
        end
      end
    end
  end
end
