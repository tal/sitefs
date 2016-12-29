require "sitefs/version"

require 'stamp'

%w{
  basic_pipeline
  content_file
  feed_config_builder
  feed_config
  renderer
  layout
  page_manager
  page_config
  render_context
  walker
  watcher
}.each do |name|
  require "sitefs/#{name}"
end

module Sitefs
  extend self
end
