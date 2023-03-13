require_relative '../lib/event_manager'
require 'rspec'

describe Event_manager do
  describe "#find_peak_hour_of_registration" do

    let(:obj1) {Event_manager.new()}
    let(:registration_dates) {["11/12/08 10:47", "11/12/08 10:10","11/12/08 12:47", "11/12/08 12:10","11/12/08 14:47", "11/12/08 15:10","11/12/08 17:47", "11/12/08 15:20"]}

    it "returns the most frequent hour of registration" do
      expect(obj1.find_peak_hour_of_registration(registration_dates)).to eql(10)
    end

  end
end
