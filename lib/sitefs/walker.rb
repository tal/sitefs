{
  'copiers' => %w{
    symlink write
  },
  'handlers' => %w{
    page asset
  },
  'view_models' => %w{
    page
  },
}.each do |type, names|
  names.each do |name|
    require "sitefs/#{type}/#{name}"
  end
end

module Sitefs
  def copier_type_for_handler handler
    handler.class.instance_variable_get :@copier
  end

  class Walker
    attr_reader :source, :dest

    HANDLERS = {
      'page' => Handlers::Page,
      '{jpeg,jpg,png,gif}' => Handlers::Asset,
    }

    COPIERS = {
      symlink: Copiers::Symlink,
      write: Copiers::Write,
    }

    def initialize source, dest
      @source = File.expand_path(source)
      @dest = File.expand_path(dest)
    end

    def copiers
      @copiers ||= Hash.new do |h, k|
        if copier = COPIERS[k]
          h[k] = copier.new(@source, @dest)
        end
      end
    end

    def files
      all = []

      context = RenderContext.new

      HANDLERS.each do |ext, klass|

        globber = File.join(@source, '**', "*.#{ext}")

        Dir[globber].each do |file|
          unless file =~ /\/[\._]/
            handler = klass.new(file, @source, context)

            all << handler
          end
        end
      end

      all
    end

    def copier_for_handler handler
      copiers[Sitefs::copier_type_for_handler(handler)]
    end

    def copy_handler handler
      if copier = copier_for_handler(handler)
        copier.copy_handler handler
      end
    end

    def copy_files
      files.each do |file|
        copy_handler file
      end
    end

  end
end
