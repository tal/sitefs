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

      if File.exist?(dest) && File.binread(dest) == content
        puts "write: #{source} => #{dest} (identical/skipped)"
        return
      end

      puts "write: #{source} => #{dest}"
      FileUtils.mkdir_p File.dirname(dest)
      File.write(dest, content)
    end
  end
end
