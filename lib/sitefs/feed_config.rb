require 'rss'

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
      RSS::Maker.make('atom') do |maker|
        @builder._channel_blk.call(maker.channel, context)

        pages.each do |page|
          maker.items.new_item do |item|
            @builder._items_blk.call(item, page)
          end
        end
      end
    end

  end
end
