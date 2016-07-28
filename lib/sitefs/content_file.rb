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

      @file_name = File.expand_path(@file_name)
    end

    def result
      @result ||= case file_name
      when /\.(md|markdown)$/
        Pipelines.markdown.call(file_contents)
      when /\.erb$/
        renderer = Renderer.new(file_contents)
        html = renderer.render(@context)
        Pipelines.content.call(html)
      else
        Pipelines.content.call(file_contents)
      end
    end

    def file_contents
      @file_contents ||= File.read(@file_name, :encoding => 'utf-8')
    end

    def title
      result[:title]
    end

    def subtitle
      result[:subtitle]
    end

    def description
      result[:description]
    end

    def xml
      result[:output]
    end

    def to_s
      xml.to_s
    end

    def finished **opts
      Pipelines.finishing(to_s, **opts)[:output].to_s
    end
  end
end
