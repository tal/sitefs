require 'sitefs/version'

require 'stamp'
require 'autoloaded'
require 'yaml'

%w{
}.each do |name|
  require "sitefs/#{name}"
end

module Sitefs
  extend self

  Autoloaded.module do |autoloading|
    # autoloading.with 'sitefs/dsl_context' => :'Sitefs::DSLContext'
  end
end
