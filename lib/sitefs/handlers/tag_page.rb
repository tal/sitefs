class Sitefs::Handlers::TagPage < Sitefs::Handlers::RubyGen
  attr_accessor :registry

  def dsl
    @dsl ||= TagPageDslContext.new registry, root_path, source_file
  end

  def delay_generation
    true
  end
end
