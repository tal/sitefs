require 'fileutils'

module Sitefs::Copiers
  class Symlink
    def initialize source_dir, dest_dir
      @dest_dir = dest_dir
      @source_dir = source_dir
    end

    def copy_handler handler
      source = handler.file_path
      dest = handler.destination_path
      dest = File.join(@dest_dir, dest)

      puts "symlink: #{source} => #{dest}"
      FileUtils.mkdir_p File.dirname(dest)
      FileUtils.symlink source, dest, force: true
    end
  end
end
