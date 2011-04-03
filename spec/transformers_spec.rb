require 'spec_helper'

describe Transformers do
  describe ".get" do
    context "when key is module" do
      it "should return module" do
        Transformers.get(Transformers::Boolean).should == Transformers::Boolean
      end
    end

    context "when key is proc" do
      it "should return proc" do
        converter = lambda { |value| return :converted_value }

        Transformers.get(converter).should == converter
      end
    end

    context "when key is registered" do
      it "should return registered converter" do
        Transformers.get(:boolean).should == Transformers::Boolean
      end
    end

    context "when key is not registered" do
      it "should return method call converter" do
        Transformers.get(:upcase).should == Transformers::MethodCall.new(:upcase)
      end
    end
  end
end
