require 'forwardable'

class Sitefs::TagPageDslContext < Sitefs::DslContext
  extend Forwardable
  def_delegators :@registry, :pages, :public_tags, :pages_tagged

  def initialize registry, path_helper
    raise "registry required for #{self.class}" unless registry.is_a? FileRegistry

    super path_helper
    @registry = registry
  end
end
