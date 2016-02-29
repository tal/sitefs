module Sitefs
  class ContentFile
    attr_reader :file_name
    def initialize dir, name, context
      @file_name = Dir[File.join(dir, "#{name}.*")].first
    end

    def pipeline
      case file_name
      when /\.(md|markdown)$/
        MarkdownPipeline
      else
        BasicPipeline
      end
    end

    def file_contents
      @file_contents ||= File.read(@file_name)
    end

    def result
      @result ||= pipeline.call(file_contents)
    end

    def title
      result[:title]
    end

    def xml
      result[:output]
    end

    def to_s
      xml.to_s
    end
  end
end
