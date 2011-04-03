require 'spec_helper'

describe Hash do
  describe "#transform" do
    it "should execute the transformations in the context of hash" do
      hash = {:key => 'value'}

      hash.transform { delete :key }

      hash.has_key?(:key).should_not be_true
    end
  end

  describe "#convert" do
    context "with :as option" do
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

    context "with :to option" do
      it "should call 'call' on the converter obtained from transformer to set converted value" do
        hash = {:key => :value}
        converter = mock
        Transformers.expects(:get).with(:converter).returns(converter)
        converter.expects(:call).with(:value).returns(:converted_value)

        hash.transform do
          convert :key, :to => :converter
        end

        hash[:key].should == :converted_value
      end

      context "for single key" do
        it "should replace value with converted value" do
          hash = {:eric => 'cartman'}

          hash.transform do
            convert :eric, :to => lambda { |value| value.upcase }
          end

          hash[:eric].should == 'CARTMAN'
        end
      end

      context "for multiple keys" do
        it "should pass multiple values to converter and set converted vlaue for key given in :as option" do
          hash = {:first_name => 'eric', :last_name => 'cartman' }

          hash.transform do
            convert :first_name, :last_name, :as => :name, :to => lambda { |first_name, last_name| first_name + ' '+ last_name }
          end

          hash[:name].should == 'eric cartman'
        end
      end
    end
  end
end

