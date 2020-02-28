require 'find'

module Sitefs::HashMaps
  refine Hash do
    def map_keys &blk
      inject({}) do |h, (k,v)|
        h[blk.call(k)] = v
        h
      end
    end

    def map_values &blk
      inject({}) do |h, (k,v)|
        h[k] = blk.call(v)
        h
      end
    end

    def find_value &blk
      val = find(&blk)
      val[1] if val
    end
  end
end

# Class used for walking a source directory and discovering what files need to be mapped
class Sitefs::Walker
  using HashMaps
  attr_reader :config

  HANDLERS = {
    'page.{md,markdown}' => Handlers::Markdown,
    'page.rb' => Handlers::RubyGen,
    'page.*erb' => Handlers::SingleErb,
    'tag-page.rb' => Handlers::TagPage,
    'scss' => Handlers::Scss,
    '*' => Handlers::Noop,
  }

  IGNORE_MATCHERS = [
    '**/node_modules',
    '**/.sass-cache',
    '**/.sass-cache/**/*.scssc',
    '**/.git',
    '**/.DS_Store',
    "**/#{Sitefs::MANIFEST_FILENAME}"
  ]

  def initialize config
    @config = config
  end

  def root_path
    @config.root_path
  end

  def ignore_matchers
    IGNORE_MATCHERS | config.ignore_patterns
  end

  def match_args
    match_args = File::FNM_CASEFOLD | File::FNM_EXTGLOB | File::FNM_PATHNAME | File::FNM_DOTMATCH
  end

  def path_should_be_ignored path
    ignore_matchers.find {|pattern| File.fnmatch(pattern, path, match_args)}
  end

  def walk
    reg = FileRegistry.new

    Dir.chdir root_path

    handlers = HANDLERS.map_keys {|ext| File.join('**', "*.#{ext}") }

    Find.find root_path do |full_path|
      path = full_path.sub(root_path, '')

      if path_should_be_ignored(path)
        Find.prune if File.directory?(path)
        next
      end

      if handler_class = handlers.find_value { |pattern, handler_class| File.fnmatch(pattern, path, match_args)}
        handler = handler_class.new(root_path, full_path)

        reg << handler if handler.should_generate?(config)
      end
    end

    reg
  end

  def watcher
    Watcher.new self
  end

  def action_set
    walk.gather_actions
  end

  def run action
    action_set.call @config, action
  end
end
