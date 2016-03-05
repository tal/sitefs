require 'listen'

module Sitefs
  class Watcher
    attr_reader :listener

    def initialize src, dest

      @listener = ::Listen.to(src) do |modified, added, removed|
        change modified, added, removed
      end

      @walker = Walker.new(src, dest)
    end

    def change modified, added, removed
      @walker.copy_files
    end
  end
end
