module Sitefs
  module LayoutType
    extend self
    def default
      standard
    end

    def standard
      :standard
    end

    def root
      :root
    end
  end
end
