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
    '**/.git',
    '**/.DS_Store',
  ]

  def initialize config
    @config = config
  end

  def root_path
    @config.root_path
  end

  def walk
    reg = FileRegistry.new

    Dir.chdir root_path

    ignore_matchers = IGNORE_MATCHERS | config.ignore_patterns
    handlers = HANDLERS.map_keys {|ext| File.join('**', "*.#{ext}") }
    match_args = File::FNM_CASEFOLD | File::FNM_EXTGLOB | File::FNM_PATHNAME

    Find.find root_path do |full_path|
      path = full_path.sub(root_path, '')

      if ignore_matchers.find {|pattern| File.fnmatch(pattern, path, match_args)}
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
