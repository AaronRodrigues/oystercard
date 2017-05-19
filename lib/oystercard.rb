require_relative 'journey'

class Oystercard
  attr_reader :balance, :entry_station, :exit_station, :in_journey, :list_of_journeys, :journey

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize
    @balance = 0
    @in_journey = false
    @list_of_journeys = []
  end

  def top_up(amount)
    raise "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if @balance + amount > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Balance too low : Top up Please' if @balance < MINIMUM_BALANCE
    @journey = Journey.new
    # @journey.start(entry_station)
    # deduct(PENALTY_FARE) if @in_journey?
    @entry_station = entry_station
    @in_journey = true
  end

  def in_journey?
    !exit_station
  end

  def touch_out(exit_station)
    deduct(MINIMUM_BALANCE)
    @entry_station
    @exit_station = exit_station
    save_journey_to_list
    @exit_station
  end

  def save_journey_to_list
    @journey = Journey.new(entry_station, exit_station)
    @list_of_journeys << @journey
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
