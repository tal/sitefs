class Sitefs::FileActionSet
  include Enumerable

  def initialize(file_actions)
    @file_actions = file_actions
    @errored_on = []
  end

  def each
    @file_actions.each do |file_action|
      yield file_action
    end
  end

  def [] i
    @file_actions[i]
  end

  def has_errors?
    !@errored_on.empty?
  end

  def output_paths
    map(&:path)
  end

  def includes_path? path
    path = File.expand_path(path)

    output_paths.include? path
  end

  def call config, action

    each do |file_action|
      begin
        file_action.perform_action config, action
      rescue Exception => e
        STDERR.puts "Error: file(#{file_action.inspect})"
        STDERR.puts e

        raise e

        file_action.render_error = e
        @errored_on << file_action
      end
    end

    self
  end
end
