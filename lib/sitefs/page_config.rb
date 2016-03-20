module Sitefs
  class PageConfig
    FILE_NAME = '_page_config.rb'

    attr_reader :config

    def initialize file_name
      @config = PageConfigBuilder.for_str File.read(file_name)
    end

    def layout_for page_handler
      blk = @config[:page_layout] && @config[:page_layout][:blk]

      blk && blk.call(page_handler)
    end

    class << self
      def file_for_dir dir, layout_name: FILE_NAME
        return unless layout_name

        unless File.directory?(dir)
          dir = File.dirname(dir)
        end

        folder = nil

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


    class PageConfigBuilder
      def initialize
        @store = {}
      end

      def method_missing name, *args, **opts, &blk
        @store[name] = {
          args: args,
          opts: opts,
          blk: blk,
        }

        nil
      end

      class << self
        def for_str str
          inst = new

          inst.instance_eval str

          inst.instance_variable_get :@store
        end
      end
    end
  end
end
