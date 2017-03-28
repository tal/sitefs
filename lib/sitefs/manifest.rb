require 'json'

module Sitefs
  MANIFEST_FILENAME = '.sitefs-manifest.json'

  class Manifest
    def initialize root_path
      @root_path = root_path

      if File.exist? manifest_path
        @manifest = ManifestFile.from_file manifest_path
      else
        @manifest = {}
      end
    end

    def clean!
      @manifest = {}
      save!
    end

    def manifest_path
      File.join @root_path, MANIFEST_FILENAME
    end

    def resolve_path path
      path.sub(@root_path, '').sub(/^\//, '').to_sym
    end

    def [] path
      @manifest[resolve_path(path)]
    end

    def []= path, value
      @manifest[resolve_path(path)] = ManifestFile.ensure(value)
    end

    def to_h
      @manifest
    end

    def as_json *opts
      to_h.inject({}) do |h, (k,v)|
        h[k] = v unless v.nil?
        h
      end
    end

    def to_json *opts
      as_json(*opts).to_json(*opts)
    end

    def save!
      File.open(manifest_path, 'w') { |f| f.puts JSON.pretty_generate(as_json) }
    end

    def delete_generated
      @manifest.each do |path, file|
        if file[:'generated_at']
          full_path = File.join(@root_path, path.to_s)
          if File.exist? full_path
            File.delete full_path
          end
          file[:'generated_at'] = nil
          puts "Deleting: #{path}"
        end
      end

      save!
    end

    ManifestFile::ALLOWED_KEYS.each do |key|
      if key[-3..-1] == '_at'
        verb = key[0...-3]
        define_method "#{verb}_path" do |path|
          now = Time.now
          send "set_path_#{key}", path, now
        end

        define_method "#{verb}?" do |path|
          !!send("path_#{key}", path)
        end
      end

      define_method "path_#{key}" do |path|
        @manifest[resolve_path(path)] && @manifest[resolve_path(path)][key]
      end

      define_method "set_path_#{key}" do |path, value|
        @manifest[resolve_path(path)] ||= ManifestFile.new
        @manifest[resolve_path(path)][key] = value
        save!
        @manifest[resolve_path(path)]
      end
    end

  end
end
