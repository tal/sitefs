FS_TEST_DIR = File.expand_path('../allieandtal.com', __FILE__)

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'sitefs'

include Sitefs

watcher = Watcher.new FS_TEST_DIR

# sleep

# walker = Walker.new(FS_TEST_DIR)

# reg = walker.walk
# action_set = reg.gather_actions.call

# if action_set.has_errors?
#   abort('some files didn\'t work')
# end
