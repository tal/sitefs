class Sitefs::FileActionSet
  include Enumerable

  def initialize(file_actions)
    @file_actions = file_actions
  end

  def each
    @file_actions.each do |file_action|
      yield file_action
    end
  end

  def call
    each(&:perform_action)
  end
end
