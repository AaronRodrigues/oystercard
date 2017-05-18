require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:journey) { double :journey }
  it { is_expected.to respond_to(:top_up).with(1).argument }
  it { is_expected.to respond_to(:in_journey?) }
  it { is_expected.to respond_to(:touch_in).with(1).argument }
  it { is_expected.to respond_to(:touch_out).with(1).argument }
  it { is_expected.to respond_to(:entry_station) }

  it 'instance has default value of 0' do
    expect(oystercard.balance).to eq(0)
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

  describe '#in_journey?' do
    it 'returns false when oystercard is initialized' do
      expect(oystercard.in_journey).to eq false
    end
    it 'returns true when oystercard is touched in' do
      oystercard.top_up 90
      oystercard.touch_in(entry_station)
      expect(oystercard.in_journey?).to eq true
    end
    it 'returns false when oystercard is touched out' do
      oystercard.top_up 90
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.in_journey?).to eq false
    end
  end

  describe '#touch_in' do
    it 'Allows touch in when sufficient credit present' do
      oystercard.top_up 90
      expect(oystercard.touch_in(entry_station)).to eq true
    end

    it 'Raises an error when balance below £1' do
      expect { oystercard.touch_in(entry_station) }.to raise_error 'Balance too low : Top up Please'
    end

    it 'Raises an error when topped up and balance goes below £1' do
      oystercard.top_up 1
      oystercard.touch_out(exit_station)
      expect { oystercard.touch_in(entry_station) }.to raise_error 'Balance too low : Top up Please'
    end

    it 'Shows us the entry_station last touched in at' do
      oystercard.top_up 10
      oystercard.touch_in(entry_station)
      expect(oystercard.entry_station).to eq entry_station
    end

    it ' shows that a card has an empty list of journeys' do
      expect(oystercard.list_of_journeys).to be_empty
    end
  end
end
