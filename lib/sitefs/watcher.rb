require 'listen'
require 'webrick'

class Sitefs::Watcher
  attr_reader :with_server, :walker, :root_path

  def initialize root_path, with_server: 8050
    @with_server = with_server
    @root_path = root_path

    puts "Listening to #{root_path}"
    
    @listener = ::Listen.to(root_path) do |modified, added, removed|
      change modified, added, removed
    end
    @listener.start
    
    @walker = Walker.new root_path
    generate

    if @server_port = with_server
      server_thread.join
    else
      sleep
    end
  end

  def server_thread
    @server_thread ||= Thread.new do
      puts "about to start server on: :#{@server_port}"
      server = WEBrick::HTTPServer.new(Port: @server_port, DocumentRoot: root_path)
      server.start
    end
  end

  def registry
    @registry ||= walker.walk
  end
  
  def action_set
    @action_set ||= registry.gather_actions
  end
  
  def generate
    puts "About to generate"
    action_set.call
    @action_set = nil
    @registry = nil
  end

  def change modified, added, removed
    puts "Change detected:"

    modified.each {|f| puts "  modified: #{f}"}
    added.each {|f| puts "  added: #{f}"}
    removed.each {|f| puts "  removed: #{f}"}

    all = (modified | added | removed)

    has_ungenerated_file = all.find do |path|
      !action_set.includes_path?(path)
    end

    generate if has_ungenerated_file

    puts ''
  end

end
