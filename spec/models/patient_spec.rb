require 'rails_helper'

RSpec.describe Patient , type: :model do
  context "name" do
    it 'should not be nil' do
      patient = build(:patient , name: nil)
      patient.validate
      expect(patient.errors).to include(:name)
    end
    it 'should be present' do
      patient = build(:patient)
      expect(patient.name).to be_truthy
    end
  end

  context "age" do
    it 'should be a number' do
      patient = build(:patient , age:"bha")
      patient.validate
      expect(patient.errors).to include(:age)
    end
    it "should be greater than 0" do
    patient = build(:patient , age:-2)
    patient.validate
    expect(patient.errors).to include(:age)
    end

    it "should be less than 99" do
    patient = build(:patient , age: 98)
    expect(patient.age).to be <99
    end
    it "must less than 99" do
      patient = build(:patient , age: 99)
      patient.validate
      expect(patient.errors).to include(:age)
    end
  end
end