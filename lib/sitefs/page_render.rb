class Sitefs::PageRender
  attr_reader :page, :template
  def initialize page:, template:
    @page, @template = page, template
  end
end
