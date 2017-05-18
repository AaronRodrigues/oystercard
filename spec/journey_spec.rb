require 'journey'

describe Journey do
  subject(:journey) { described_class.new(nil, nil) }
  let(:oystercard) { double('oystercard', touch_in: 'entry station', touch_out: 'exit station') }
  let(:journey_completed) { described_class.new('entry_point', 'exit_point') }
  let(:oystercard2) {double("oystercard", touch_in: nil, touch_out: nil)}
  let(:journey_with_no_touch_in) { described_class.new(nil, 'exit_point') }
  let(:journey_with_no_touch_out) { described_class.new('entry_point', nil) }

  it 'is a type of Journey' do
    expect(journey).to be_a Journey
  end

  it 'has a beginning point ' do
    expect(journey.entry_point).to eq nil
  end

  it 'has a ending point' do
    expect(journey.exit_point).to eq nil
  end

  describe '#journey' do
    it 'stores a journey to list_of_journeys' do
      oystercard.touch_in('entry_station')
      oystercard.touch_out('exit_station')
      expect(journey.show_last_trip).to be journey
    end

    it 'knows if a journey is not complete' do
      allow(journey_with_no_touch_in).to receive(:complete) { false }
      expect(journey_with_no_touch_in.complete).to eq false
    end
  end

  describe '#fare' do
    it 'calculates the fare' do
      # oystercard.touch_in("entry_station")
      # p journey.entry_point
      # oystercard.touch_out("exit_station")

      expect(journey_completed.fare).to eq described_class::MINIMUM_FARE
    end

    it "charges the penalty fare if a passenger doesn't touch in" do
      # oystercard2.touch_in(nil)
      # p @entry_point
      # oystercard2.touch_out('Aldgate')
      # p @entry_point
      p journey_with_no_touch_in.entry_point
      expect(journey_with_no_touch_in.fare).to eq described_class::PENALTY_FARE
    end

    it 'charges a penalty fare if a passenger does not touch out' do
      expect(journey_with_no_touch_out.fare).to eq described_class::PENALTY_FARE
    end
  end
end
