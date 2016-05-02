require 'atom'

module Sitefs
  class FeedConfig
    attr_reader :context

    def initialize builder:, context:
      @builder = builder
      @context = context
    end

    def pages
      @pages ||= @builder._pages_blk.call(context)
    end

    def make_feed
      Atom::Feed.new do |feed|
        @builder._channel_blk.call(feed, context)

        pages.each do |page|

          feed.entries << Atom::Entry.new do |entry|
            @builder._items_blk.call(entry, page)
          end
        end
      end.to_xml
    end

  end
end
