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
      it "should rename the key" do
        hash = {:stan => 'marsh'}

        hash.transform { convert :stan, :as => :eric }

        hash.has_key?(:stan).should_not be_true
        hash.has_key?(:eric).should be_true
        hash[:eric].should == 'marsh'
      end
    end

    describe "to" do
      it "should apply conversion logic as per converter lamdda" do
        hash = {:eric => 'cartman'}

        hash.transform do
          convert :eric, :to => lambda { |value| value.upcase }
        end

        hash[:eric].should == 'CARTMAN'
      end
    end
  end
end
