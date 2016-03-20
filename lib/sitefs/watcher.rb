require 'listen'

module Sitefs
  class Watcher

    def initialize src, dest

      @listener = ::Listen.to(src) do |modified, added, removed|
        change modified, added, removed
      end

      @walker = Walker.new(src, dest)
      @walker.copy_files
    end

    def start
      @listener.start
    end

    def change modified, added, removed
      puts "Change detected:"

      modified.each {|f| puts "  modified: #{f}"}
      added.each {|f| puts "  added: #{f}"}
      removed.each {|f| puts "  removed: #{f}"}

      puts ''

      begin
        @walker.copy_files
      rescue Exception => e
        puts "Exception!!!: #{e.to_s}"
      end

      puts ''
    end
  end
end
