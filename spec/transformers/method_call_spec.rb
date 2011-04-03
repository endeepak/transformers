require 'spec_helper'

describe Transformers::MethodCall do
  context "when method name is :upcase" do
    subject  { Transformers::MethodCall.new(:upcase) }

    it { should convert('hello').to('HELLO') }
    it { should == Transformers::MethodCall.new(:upcase) }
    it { should == Transformers::MethodCall.new('upcase') }
  end
end
