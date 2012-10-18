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
          }.to raise_error(/Can't apply transformations on "value". Expected a Hash/)
        end
      end
    end
  end

  describe "#convert" do
    context "with :as option" do
      context "for single key" do
        it "should rename the key" do
          hash = {:stan => 'marsh'}

          hash.convert :stan, :as => :eric

          hash.should_not have_key(:stan)
          hash.should have_key(:eric)
          hash[:eric].should == 'marsh'
        end
      end

      context "for multiple keys" do
        it "should combine the keys to single key" do
          hash = {:begin => 12, :end => 22}

          hash.convert :begin, :end, :as => :range

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

        hash.convert :key, :to => :converter

        hash[:key].should == :converted_value
      end

      context "for single key" do
        context "when key exists" do
          it "should replace value with converted value" do
            hash = {:eric => 'cartman'}

            hash.convert :eric, :to => lambda { |value| value.upcase }

            hash[:eric].should == 'CARTMAN'
          end
        end

        context "when key does not exist" do
          it "should not apply conversion" do
            hash = {:eric => 'cartman'}

            hash.convert :stan, :to => :kyle

            hash[:eric].should == 'cartman'
            hash.should_not have_key(:stan)
          end
        end
      end

      context "when hash has indifferent access" do
        it "should apply conversion" do
          hash = {'eric' => 'cartman'}.with_indifferent_access

          hash.convert :eric, :to => :upcase

          hash['eric'].should == 'CARTMAN'
        end
      end

      context "for multiple keys" do
        context "when all keys exists" do
          it "should pass multiple values to converter and set converted vlaue for key given in :as option" do
            hash = {:first_name => 'eric', :last_name => 'cartman' }

            hash.convert :first_name, :last_name, :as => :name, :to => lambda { |first_name, last_name| "#{first_name} #{last_name}" }

            hash[:name].should == 'eric cartman'
          end
        end

        context "when one of keys exists" do
          it "should pass multiple values to converter and set converted vlaue for key given in :as option" do
            hash = {:first_name => 'eric' }

            hash.convert :first_name, :last_name, :as => :name, :to => lambda { |first_name, last_name| "#{first_name} #{last_name}" }

            hash[:name].should == 'eric '
          end
        end

        context "when none of keys exists" do
          it "should not apply conversion" do
            hash = {}

            hash.convert :first_name, :last_name, :as => :name, :to => lambda { |first_name, last_name| "#{first_name} #{last_name}" }

            hash.should_not have_key(:name)
          end
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

      expect { hash.rename :stan }.to raise_error(/Missing options : :to/)
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

      expect { hash.copy :stan }.to raise_error(/Missing options : :to/)
    end
  end
end

