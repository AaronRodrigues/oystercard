class Oystercard
  attr_reader :balance, :entry_station, :exit_station, :in_journey,:list_of_journeys, :journey

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
  	fail "Balance too low : Top up Please" if @balance < MINIMUM_BALANCE
    # start_journey(entry_station)
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

  # def start_journey(entry_station, exit_station)
  #   journey = Journey.new(entry_station, exit_station)
  # end

  def deduct(amount)
    @balance -= amount
  end

end

# card = Oystercard.new
# card.top_up(20)
# card.touch_in('Aldgate')
# p card.touch_out('Westminister')
# p card.show_last_journey
