require 'html/pipeline'
require 'html/pipeline/rouge_filter'

module Sitefs
  class TitleDeterminer < HTML::Pipeline::Filter
    def call
      if node = doc.css('h1:first-child').first
        text = node.text.strip

        result[:title] = node.text unless text.empty?
      end

      if node = doc.css('h1:first-child + h2').first
        text = node.text.strip

        result[:subtitle] = node.text unless text.empty?
      end

      doc
    end
  end

  ContentHtmlPipeline = HTML::Pipeline.new([
    TitleDeterminer,
  ])

  MarkdownContentPipeline = HTML::Pipeline.new(
    [HTML::Pipeline::MarkdownFilter] + ContentHtmlPipeline.filters, {
    gfm: true,
  })

  FinishingPipeline = HTML::Pipeline.new([
    HTML::Pipeline::AutolinkFilter,
    HTML::Pipeline::RougeFilter,
  ])
end
