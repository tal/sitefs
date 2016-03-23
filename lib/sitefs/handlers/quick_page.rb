module Sitefs
  module Handlers
    class QuickPage
      attr_reader :file_path, :context, :root
      @copier = :write

      def initialize file_path, root, context
        @file_path = File.expand_path(file_path)
        @context = context
        @root = root

        context.page_manager.pages << self
      end

      def content
        @content ||= ContentFile.new(file_path, context: @context)
      end

      def tag_strs
        %w{_quick-page}
      end

      def tagged? str
        tag_strs.include? str
      end

      def published_at
        File.birthtime(@file_path)
      end

      def published?
        published_at && published_at < Time.now
      end

      def layout
        @layout ||= Layout.for_dir File.dirname(file_path)
      end

      def page_config
        @page_config ||= PageConfig.for_dir(file_path)
      end

      def page_layout_file_name
        page_config.layout_for self
      end

      def page_layout
        @page_layout ||= Layout.for_dir(file_path, layout_name: page_layout_file_name)
      end

      def destination_path
        file_path.gsub('.page', '').sub(File.expand_path(root), '')
      end

      def href
        destination_path.sub('/index.html', '')
      end

      def to_s
        layouts = [page_layout, layout].compact

        layouts.reduce(content.to_s) do |prev, layout|
          layout.generate(context) { prev }
        end
      end
    end
  end
end
