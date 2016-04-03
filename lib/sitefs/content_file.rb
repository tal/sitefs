require 'github/markdown'
require 'erb'

module Sitefs
  class ContentFile
    attr_reader :file_name
    def initialize dir, name = nil, context:nil

      @context = context
      if name
        @file_name = Dir[File.join(dir, "#{name}.*")].first || File.join(dir, name)
      else
        @file_name = dir
      end

      puts "@file_name: #{@file_name}"

      @file_name = File.expand_path(@file_name)
    end

    def result
      @result ||= case file_name
      when /\.(md|markdown)$/
        MarkdownContentPipeline.call(file_contents)
      when /\.erb$/
        renderer = Renderer.new(file_contents)
        html = renderer.render(@context)
        ContentHtmlPipeline.call(html)
      else
        ContentHtmlPipeline.call(file_contents)
      end
    end

    def file_contents
      @file_contents ||= File.read(@file_name)
    end

    def title
      result[:title]
    end

    def subtitle
      result[:subtitle]
    end

    def xml
      result[:output]
    end

    def to_s
      xml.to_s
    end
  end
end
