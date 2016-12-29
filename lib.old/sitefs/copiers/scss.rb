require 'fileutils'
require 'sass'

module Sitefs::Copiers
  class SCSS
    def initialize source_dir, dest_dir
      @dest_dir = dest_dir
      @source_dir = source_dir
    end

    def copy_handler handler
      source = File.expand_path(handler.file_path)
      dest = handler.destination_path
      dest = File.join(@dest_dir, dest).sub(/scss$/, 'css')

      content = content_for(source)

      if File.exist?(dest) && File.binread(dest) == content
        puts "scss: #{source} => #{dest} (identical/skipped)"
        return
      end

      puts "scss: #{source} => #{dest}"
      FileUtils.mkdir_p File.dirname(dest)
      File.write(dest, content)
    end

    def content_for original_file_name

      options = {
        cache: true,
        syntax: :scss,
        style: :compressed,
        filename: original_file_name,
      }

      Sass::Engine.new(File.read(original_file_name), options).render
    end
  end
end
