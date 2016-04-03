module Sitefs
  module Handlers
    module BasePage
      def view_model
        @view_model ||= ViewModels::Page.new(self)
      end

      def href
        destination_path.sub('/index.html', '')
      end

      def published?
        published_at && published_at < Time.now
      end

      def layout
        raise "implement"
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

      def title
        content.title
      end

      def subtitle
        content.subtitle
      end

      def destination_path
        raise 'implement'
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
    end
  end
end
