class Sitefs::Handlers::TagPage < Sitefs::Handlers::RubyGen
  attr_accessor :registry

  def dsl
    @dsl ||= TagPageDslContext.new registry, path_helper
  end

  def delay_generation
    true
  end
end
