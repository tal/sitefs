$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'sitefs'

include Sitefs

FS_TEST_DIR = File.expand_path('../inline-site', __FILE__)

walker = Walker.new(FS_TEST_DIR)

reg = walker.walk
reg.gather_actions.each do |action|
  puts "#{action.content_hash} - #{action.path}"
  puts "should_write? #{action.should_write?}"
  puts action.content

  action.perform_action
end
