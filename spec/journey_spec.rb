require 'journey'

describe Journey do
  subject(:journey) { described_class.new(nil, nil) }
  let(:journey_completed) { described_class.new('entry_point', 'exit_point') }
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

  describe '#start' do
    it 'can start a journey' do
      journey.start(:station)
      expect(journey.entry_point).to eq :station
    end
  end

  describe '#finish' do
    it 'can finish a journey' do
      journey.finish(:station)
      expect(journey.exit_point).to eq :station
    end

    it 'should return itself when exiting a journey' do
      expect(journey.finish(:station)).to eq journey
    end
  end

  describe '#complete?' do
    it 'knows if a journey is complete' do
      expect(journey_completed.complete?).to eq true
    end

    it 'know if a journey is not complete' do
      expect(journey_with_no_touch_out.complete?).to eq false
    end

    it 'knows if a journey is not complete' do
      expect(journey_with_no_touch_in.complete?).to eq false
    end
  end

  describe '#fare' do
    it "returns the minimum fare when journey is complete" do
      journey.start(:station)
      journey.finish(:another_station)
      expect(journey.fare).to eq described_class::MINIMUM_FARE
    end

    it "charges the penalty fare if a passenger doesn't touch in" do
      expect(journey_with_no_touch_in.fare).to eq described_class::PENALTY_FARE
    end

    it 'has a penalty fare by default' do
      expect(journey.fare).to eq described_class::PENALTY_FARE
    end

    it 'charges a penalty fare if a passenger does not touch out' do
      expect(journey_with_no_touch_out.fare).to eq described_class::PENALTY_FARE
    end
  end
end
