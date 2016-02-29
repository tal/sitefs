module Sitefs
  module Handlers
    class Asset
      attr_reader :file_path, :root
      @copier = :symlink

      def initialize file, root, context
        @root = root
        @file_path = File.expand_path(file)
      end

      def destination_path
        file_path.gsub('.page', '').sub(File.expand_path(root), '')
      end

    end
  end
end
