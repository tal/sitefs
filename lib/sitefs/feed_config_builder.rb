module Sitefs
  class FeedConfigBuilder
    attr_reader :_channel_blk, :_items_blk, :_pages_blk

    def channel &blk
      @_channel_blk = blk
    end

    def pages &blk
      @_pages_blk = blk
    end

    def items &blk
      @_items_blk = blk
    end

    class << self
      def from_file file
        from_str File.read(file)
      end

      def from_str str
        builder = new

        builder.instance_eval str

        builder
      end
    end
  end
end
