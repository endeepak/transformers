require 'spec_helper'

describe Transformers do
  describe ".get" do
    context "when key is a proc" do
      it "should return proc" do
        transformer = lambda { |value| return :converted_value }

        Transformers.get(transformer).should == transformer
      end
    end

    context "when key is a module" do
      it "should return module" do
        Transformers.get(Transformers::Boolean).should == Transformers::Boolean
      end
    end

    context "when key is symbol" do
      context "standard transformer" do
        it "should return standard transformer" do
          Transformers.get(:boolean).should == Transformers::Boolean
        end
      end

      context "registered transformer" do
        it "should return registered transformer" do
          transformer = lambda {|value| value.downcase }
          Transformers.register(:downcase, transformer)

          Transformers.get(:downcase).should == transformer
        end
      end

      context "not registered" do
        it "should return method call transformer" do
          Transformers.get(:upcase).should == Transformers::MethodCall.new(:upcase)
        end
      end
    end

    context "when key is anything else" do
      it "should raise error" do
        expect { Transformers.get("UNKNOWN") }.to raise_error('The "UNKNOWN" transformer is not supported')
      end
    end
  end
end
