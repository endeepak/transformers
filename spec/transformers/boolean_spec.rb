require 'spec_helper'

describe Transformers::Boolean do
  it { should convert('true').to(true)}
  it { should convert(true).to(true)}

  it { should convert(false).to(false)}
  it { should convert('false').to(false)}
  it { should convert(nil).to(false)}
  it { should convert('').to(false)}
  it { should convert('  ').to(false)}
  it { should convert('anything else').to(false)}
end
