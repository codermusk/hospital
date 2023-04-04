require 'rails_helper'

RSpec.describe Appointment , type: :model do
  context "appointment_date" do
    it 'should not be nil' do
      appointment = build(:appointment , appointment_date: nil)
      appointment.validate
      expect(appointment.errors).to include(:appointment_date)
    end
    it 'should present' do
      appointment = build(:appointment)
      expect(appointment.appointment_date).to be_truthy
    end
  end

  context "time" do
    it 'should not be nil' do
      appointment = build(:appointment , time:nil )
      appointment.validate
      expect(appointment.errors).to include(:time)

    end
    it 'should be present' do
      appointment = build(:appointment)
      expect(appointment.time).to be_truthy

    end
  end


  context "doctor" do
    it 'must not be nil' do
      appointment = build(:appointment , doctor: nil)
      expect(appointment.save).to be_falsey
    end

    it "must have associations" do
      appointment = build(:appointment)
      expect(appointment.doctor).to be_truthy

    end

  end

  context "patient" do
    it "must not be nil" do
      appointment = build(:appointment , patient: nil)
      appointment.validate
      expect(appointment.errors).to include(:patient)
    end

    it "must have assoication" do
      appointment = build(:appointment)
      expect(appointment.patient).to be_an_instance_of(Patient)
    end


  end

  context "prescribtion" do
    it "has association" do
      assocaiation = Appointment.reflect_on_association(:prescribtion).macro
      expect(assocaiation).to be(:has_one)
    end

  end

  context "association" do
    it 'has  one bill' do
      association = Appointment.reflect_on_association(:bill).macro
      expect(association).to be(:has_one)
    end
  end

end