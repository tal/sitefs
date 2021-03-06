require 'uri'

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

      if node = doc.css('h2 + p:nth-of-type(1)').first
        text = node.text.strip

        result[:description] = node.text[0..199] unless text.empty?
      end

      doc
    end
  end

  class RelativePathFilter < HTML::Pipeline::Filter
    def call
      base_path = context[:image_base_path] || context[:base_path]
      context_path = context[:context_path]

      unless base_path || context_path
        return doc
      end

      doc.search('img').each do |img|
        next if img['src'].nil?

        src = img['src'].strip

        if src.start_with?('/') || src.start_with?('http')
        elsif context_path
          src = File.join(context_path, src)
        end

        if base_path && src.start_with?('/')
          src = URI.join(base_path, src).to_s
        end

        img['src'] = src
      end
      doc

    end

  end

  module HtmlPipelines
    extend self

    def content
      HTML::Pipeline.new([
         TitleDeterminer,
         HTML::Pipeline::RougeFilter,
       ])
    end

    def markdown
      HTML::Pipeline.new(
          [
            HTML::Pipeline::MarkdownFilter,
            TitleDeterminer,
            HTML::Pipeline::AutolinkFilter,
            HTML::Pipeline::RougeFilter,
          ], {
          gfm: true,
        })
    end

    def finishing str, **opts

      filters = [
        RelativePathFilter,
        HTML::Pipeline::AutolinkFilter,
        HTML::Pipeline::RougeFilter,
      ]

      HTML::Pipeline.new(filters, **opts).call(str)
    end
  end
end
