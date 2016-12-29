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
      def file_for_dir dir, layout_name: FILE_NAME
        return unless layout_name

        folder = nil

        unless File.directory?(dir)
          dir = File.dirname(dir)
        end

        orig = Dir.pwd

        Dir.chdir dir

        while !File.exists?(layout_name) do
          if Dir.pwd == '/'
            return
          end

          Dir.chdir '..'
        end

        folder = Dir.pwd

        Dir.chdir orig

        if folder
          File.join folder, layout_name
        end
      end

      def for_dir dir, **opts
        (file_name = file_for_dir(dir, **opts)) && new(file_name)
      end
    end
  end
end
