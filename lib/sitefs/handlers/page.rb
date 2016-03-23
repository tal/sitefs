module Sitefs
  module Handlers
    class Page
      attr_reader :file_path, :context, :root
      @copier = :write

      {
        published: 'published',
        tags: 'tags',
      }.each do |name, file|
        define_method "#{name}_file_name" do
          File.join(file_path, file)
        end

        define_method "#{name}_exists?" do
          File.exists?(File.join(file_path, file))
        end
      end

      def initialize file, root, context
        @file_path = File.expand_path(file)
        @root = root

        @context = context
        context.page_manager.pages << self

        if !File.directory? @file_path
          raise "File: #{@file_path} is not a directory"
        end
      end

      def tag_strs
        @tag_strs ||= if tags_exists?
          File.read(tags_file_name).split("\n")
        else
          []
        end
      end

      def tagged? str
        tag_strs.include? str
      end

      def content
        @content ||= ContentFile.new(file_path, 'content', context: @context)
      end

      def published_at
        @published_at ||= if published_exists?
          published_info = File.read(published_file_name).chomp

          if published_info.empty?
            File.birthtime(published_file_name)
          else
            Time.parse(published_info)
          end
        end
      end

      def published?
        published_at && published_at < Time.now
      end

      def layout
        @layout ||= Layout.for_dir file_path
      end

      def page_config
        @page_config ||= PageConfig.for_dir(file_path)
      end

      def page_layout_file_name
        page_config && page_config.layout_for(self)
      end

      def page_layout
        @page_layout ||= page_layout_file_name && Layout.for_dir(file_path, layout_name: page_layout_file_name)
      end

      def destination_path
        dir = file_path.gsub('.page', '').sub(File.expand_path(root), '')

        File.join(dir, 'index.html')
      end

      def href
        destination_path.sub('/index.html', '')
      end

      def view_model
        @view_model ||= ViewModels::Page.new(self)
      end

      def html_str
        @html_str ||= begin
          layouts = [page_layout, layout].compact

          context.current_page = view_model

          str = layouts.reduce(content.to_s) do |prev, layout|
            layout.generate(context) { prev }
          end

          context.current_page = nil

          str
        end
      end

      def result
        @result ||= FinishingPipeline.call(html_str)
      end

      def title
        content.title
      end

      def subtitle
        content.subtitle
      end

      def xml
        result[:output]
      end

      def to_s
        xml.to_s
      end

    end
  end
end
