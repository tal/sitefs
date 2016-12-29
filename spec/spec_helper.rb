$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'sitefs'

include Sitefs

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = :should
  end

  # config.expect_with(:rspec) { |c| c.syntax = :should }
end

FS_TEST_DIR = File.expand_path('../../inline-site', __FILE__)

require 'rspec/expectations'

RSpec::Matchers.define :include_exactly_once do |expected|
  count = nil
  match do |actual|
    count = subject.scan(/(?=#{expected})/).count

    count.should be(1)
  end

  description { "include #{expected.inspect} exactly once" }

  max_length = 500
  failure_message_for_should do |actual|
    if actual.length > max_length
      actual = actual[0..max_length-3].inspect + '...'
    else
      actual = actual.inspect
    end

    "expected that #{actual} would contain #{expected.inspect} exactly once got #{count} times"
  end
end

