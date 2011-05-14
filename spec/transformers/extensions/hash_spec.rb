require 'spec_helper'

describe Hash do
  describe "#transform" do
    context "without any arguments" do
      it "should execute the transformations in the context of hash" do
        hash = {:key => 'value'}

        hash.transform { delete :key }

        hash.should_not have_key(:key)
      end
    end

    context "with key as argument" do
      context "when value is not a hash" do
        it "should execute the transformations in the context of value" do
          hash = {:key => { :nested_key => 'value'} }

          hash.transform(:key) { delete :nested_key }

          hash[:key].should_not have_key(:nested_key)
        end
      end

      context "when value in nil" do
        it "should not execute any transformations" do
          hash = {:key => nil }

          hash.transform(:key) { delete :nested_key }

          hash[:key].should be_nil
        end
      end

      context "when value is not a hash" do
        it "should raise error" do
          hash = {:key => 'value' }

          expect {
            hash.transform(:key) do
              convert :foo, :as => :bar
            end
          }.should raise_error(/Can't apply transformations on "value". Expected a Hash/)
        end
      end
    end
  end

  describe "#convert" do
    context "with :as option" do
      context "for single key" do
        it "should rename the key" do
          hash = {:stan => 'marsh'}

          hash.transform { convert :stan, :as => :eric }

          hash.should_not have_key(:stan)
          hash.should have_key(:eric)
          hash[:eric].should == 'marsh'
        end
      end

      context "for multiple keys" do
        it "should combine the keys to single key" do
          hash = {:begin => 12, :end => 22}

          hash.transform { convert :begin, :end, :as => :range }

          hash.should_not have_key(:begin)
          hash.should_not have_key(:end)
          hash.should have_key(:range)
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

  describe "rename" do
    it "should rename the key" do
      hash = {:stan => 'marsh'}

      hash.rename :stan, :to => :eric

      hash.should_not have_key(:stan)
      hash.should have_key(:eric)
      hash[:eric].should == 'marsh'
    end

    it "should raise error if :to option is missing" do
      hash = {:stan => 'marsh'}

      expect { hash.rename :stan }.should raise_error(/Missing options : :to/)
    end
  end

  describe "copy" do
    it "should copy the value to another key" do
      hash = {:stan => 'southpark'}

      hash.copy :stan, :to => :eric

      hash.should have_key(:eric)
      hash.should have_key(:stan)
      hash[:eric].should == hash[:stan]
    end

    it "should raise error if :to option is missing" do
      hash = {:stan => 'marsh'}

      expect { hash.copy :stan }.should raise_error(/Missing options : :to/)
    end
  end
end

