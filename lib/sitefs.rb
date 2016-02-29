require "sitefs/version"

%w{
  basic_pipeline
  content_file
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
