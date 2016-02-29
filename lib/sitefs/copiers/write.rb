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

      puts "write: #{source} => #{dest}"
      FileUtils.mkdir_p File.dirname(dest)
      File.open(dest, "w") { |io| io.puts handler.to_s }
    end
  end
end
