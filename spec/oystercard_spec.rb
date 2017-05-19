require 'oystercard'
require 'journey'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:journey) { double :journey }
  it { is_expected.to respond_to(:in_journey?) }
  it { is_expected.to respond_to(:entry_station) }
  it { is_expected.to respond_to(:journey) }

  it 'instance has default value of 0' do
    expect(oystercard.balance).to eq(0)
  end

  it ' shows that a card has an empty list of journeys' do
    expect(oystercard.list_of_journeys).to be_empty
  end

  describe '#top_up' do
    it 'can top up the balance' do
      expect { oystercard.top_up 1 }.to change { oystercard.balance }.by 1
    end
  end

  it 'raises an error if the maximum balance is exceeded' do
    maximum_balance = Oystercard::MAXIMUM_BALANCE
    oystercard.top_up maximum_balance
    expect { oystercard.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
  end

  describe '#touch_in' do

    it 'Raises an error when balance below £1' do
      expect { oystercard.touch_in(entry_station) }.to raise_error 'Balance too low : Top up Please'
    end

    it 'creates a new journey' do
      oystercard.top_up 90
      oystercard.touch_in(:station)
      expect(oystercard.journey).to be_a Journey
    end

    it 'save the journey with the entry station' do
      oystercard.top_up 90
      oystercard.touch_in(:station)
      expect(oystercard.journey.entry_point).to eq :station
    end

    it 'saves a journey to the list of journeys' do
      allow(journey).to receive(:start)
      oystercard = Oystercard.new(journey)
      oystercard.top_up 90
      oystercard.touch_in(:station)
      expect(oystercard.list_of_journeys).to eq [journey]
    end
  end

  describe '#touch_out' do
    it 'updates the journey object with an exit station' do
      journey = Journey.new
      oystercard = Oystercard.new(journey)
      oystercard.top_up 90
      oystercard.touch_in(:entry_station)
      oystercard.touch_out(:exit_station)
      expect(oystercard.list_of_journeys.last.exit_point).to eq :exit_station
    end
  end
end
