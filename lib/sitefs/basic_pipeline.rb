require 'html/pipeline'
require 'html/pipeline/rouge_filter'

module Sitefs
  class TitleDeterminer < HTML::Pipeline::Filter
    def call
      if node = doc.css('h1').first
        result[:title] = node.text
      end

      doc
    end
  end

  BasicPipeline = HTML::Pipeline.new([
    TitleDeterminer,
    HTML::Pipeline::AutolinkFilter,
    HTML::Pipeline::RougeFilter
  ])

  MarkdownPipeline = HTML::Pipeline.new(
    [HTML::Pipeline::MarkdownFilter] + BasicPipeline.filters, {
    gfm: true,
  })
end
