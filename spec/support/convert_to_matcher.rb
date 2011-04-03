RSpec::Matchers.define :convert do |value|
  chain :to do |expected_value|
    @expected_value = expected_value
  end

  match do
    described_class.call(value) == @expected_value
  end

  failure_message_for_should do |model|
    "expected #{described_class} to convert #{value.inspect} to #{@expected_value.inspect}"
  end

  description do
    "convert #{value.inspect} to #{@expected_value.inspect}"
  end
end
