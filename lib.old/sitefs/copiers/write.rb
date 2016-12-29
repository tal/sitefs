require 'digest/sha2'

module Sitefs::Copiers
  class Write
    def initialize source_dir, dest_dir
      @dest_dir = dest_dir
      @source_dir = source_dir
    end

    def copy_handler handler
      source = handler.file_path
      dest = handler.destination_path

      dest = File.join(@dest_dir, dest)

      content = handler.to_s

      if File.exist?(dest)
        current_sha = Digest::SHA2.hexdigest(content)
        new_sha = Digest::SHA2.hexdigest(File.binread(dest))

        if current_sha == new_sha
          puts "write: #{source} => #{dest} (identical/skipped)"
          return
        end
      end

      puts "write: #{source} => #{dest}"
      FileUtils.mkdir_p File.dirname(dest)
      # File.write(dest, content)

      File.open(dest, "w:UTF-8") do |f|
        f.write content
      end
    end
  end
end
