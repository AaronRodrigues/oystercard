class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_point, :exit_point, :complete

  def initialize(entry_point = nil, exit_point = nil)
    @entry_point = entry_point
    @exit_point = exit_point
  end

  def start(entry_point)
    @entry_point = entry_point
  end

  def finish(exit_point)
    @exit_point = exit_point
    self
  end

  def complete?
    !!@entry_point && !!@exit_point
  end

  def fare
    return PENALTY_FARE unless complete?
    MINIMUM_FARE
  end
end
