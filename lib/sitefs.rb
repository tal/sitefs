require "sitefs/version"

%w{
  basic_pipeline
  content_file
  feed_config_builder
  feed_config
  renderer
  layout
  page_manager
  render_context
  walker
}.each do |name|
  require "sitefs/#{name}"
end

module Sitefs
  extend self
end
