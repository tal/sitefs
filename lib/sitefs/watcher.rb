require 'listen'
require 'webrick'

class Sitefs::Watcher
  attr_reader :with_server, :walker

  def initialize walker
    @config = walker.config
    @listener = ::Listen.to(root_path) do |modified, added, removed|
      change modified, added, removed
    end

    @walker = walker
  end

  def root_path
    @config.root_path
  end

  def port
    @config.port
  end

  def start
    puts "Listening to #{root_path}"

    action_set.call @config, :write
    @listener.start

    if @port = port
      server_thread.join
    else
      sleep
    end
  end

  def server_thread
    @server_thread ||= Thread.new do
      puts "about to start server on: http://127.0.0.1:#{@port}"
      webrick_config = WEBrick::Config::FileHandler.merge({
        :FancyIndexing     => true,
        :NondisclosureName => [
          ".ht*", "~*",
        ],
      })

      server = WEBrick::HTTPServer.new(
        Port: @port,
        DocumentRoot: root_path,
        SitefsConfig: @config,
       ).tap { |o| o.unmount("") }
      server.mount('', Servlet, root_path, webrick_config )
      server.start
    end
  end

  def registry
    walker.walk
  end

  def action_set
    registry.gather_actions
  end

  def change modified, added, removed

    modified = modified.map{|f| f.sub(root_path, '')}.select{|f| !walker.path_should_be_ignored(f)}
    added = added.map{|f| f.sub(root_path, '')}.select{|f| !walker.path_should_be_ignored(f)}
    removed = removed.map{|f| f.sub(root_path, '')}.select{|f| !walker.path_should_be_ignored(f)}

    all = (modified | added | removed)

    return if all.empty?

    as = action_set

    has_ungenerated_file = all.find do |path|
      !as.includes_path?(path)
    end

    if has_ungenerated_file
      puts "Change detected:"
      modified.each {|f| puts "  modified: #{f}"}
      added.each {|f| puts "  added: #{f}"}
      removed.each {|f| puts "  removed: #{f}"}
      puts "Perform actions: "
      as.call(walker.config, :write)
    end

    puts ''
  end

end
