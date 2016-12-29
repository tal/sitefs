require 'forwardable'

class Sitefs::TagPageDslContext < Sitefs::DslContext
  extend Forwardable
  def_delegators :@registry, :pages, :public_tags, :pages_tagged

  def initialize registry, root_path, source_file
    raise "registry required for #{self.class}" unless registry.is_a? FileRegistry

    super root_path, source_file
    @registry = registry
  end
end
