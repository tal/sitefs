module Sitefs
  module Handlers
    class QuickPage
      include BasePage

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

      def destination_path
        file_path.gsub(/\.page.*$/, '.html').sub(File.expand_path(root), '')
      end

      def layout
        @layout ||= Layout.for_dir File.dirname(file_path)
      end

      def to_s
        html_str
      end
    end
  end
end
