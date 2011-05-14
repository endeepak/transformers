RSpec::Matchers.define :convert do |value|
  chain :to do |expected_value|
    @expected_value = expected_value
  end

  match do
    @converted_value = subject.call(value)
    @converted_value == @expected_value
  end

  failure_message_for_should do |model|
    "expected #{subject} to convert #{value.inspect} to #{@expected_value.inspect} but was #{@converted_value.inspect}"
  end

  description do
    "convert #{value.inspect} to #{@expected_value.inspect}"
  end
end
