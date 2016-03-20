require 'fileutils'

module Sitefs::Copiers
  class Copy
    def initialize source_dir, dest_dir
      @dest_dir = dest_dir
      @source_dir = source_dir
    end

    def copy_handler handler
      source = handler.file_path
      dest = handler.destination_path
      dest = File.join(@dest_dir, dest)

      puts "copy: #{source} => #{dest}"
      dir = File.dirname(dest)
      FileUtils.mkdir_p dir

      if File.exist?(dest)
        FileUtils.rm dest
      end
      FileUtils.cp source, dest
    end
  end
end
