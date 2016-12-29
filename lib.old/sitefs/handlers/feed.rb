module Sitefs::Handlers
  class Feed
    attr_reader :file_path, :root, :context
    @copier = :write

    def initialize file, root, context
      @file_path = File.expand_path(file)
      @root = root

      @context = context
    end

    def config_builder
      @config_builder ||= ::Sitefs::FeedConfigBuilder.from_file @file_path
    end

    def feed_config
      @feed_config ||= ::Sitefs::FeedConfig.new context: context, builder: config_builder
    end

    def destination_path
      file_path.gsub('.page', '')
        .sub(/feed(?:\.rb)?/, 'atom.xml')
        .sub(File.expand_path(root), '')
    end

    def to_s
      feed_config.make_feed
    end
  end
end
