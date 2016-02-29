require 'erb'

module Sitefs
  class Layout
    FILE_NAME = '_layout.html.erb'

    attr_reader :file_path

    def initialize file_path
      @file_path = file_path
    end

    def content
      @content ||= File.read(file_path)
    end

    def renderer
      @renderer ||= Renderer.new(content)
    end

    def generate context, &blk
      renderer.render(context, &blk)
    end

    class << self
      def file_for_dir dir

        folder = nil

        orig = Dir.pwd

        Dir.chdir dir

        while !File.exists?(FILE_NAME) do
          if Dir.pwd == '/'
            return
          end

          Dir.chdir '..'
        end

        folder = Dir.pwd

        Dir.chdir orig

        if folder
          File.join folder, FILE_NAME
        end
      end

      def for_dir dir
        (file_name = file_for_dir(dir)) && new(file_name)
      end
    end
  end
end
