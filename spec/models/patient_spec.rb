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
  context "sex" do
    it 'should present' do
      patient = build(:patient , sex: nil)
      patient.validate
      expect(patient.errors).to include(:sex)
    end

    it "must present" do
      patient = build(:patient)
      expect(patient.sex).to be_truthy
    end

  end
  context "mobile_number" do
    it 'should be of length 10' do
    patient = build(:patient , mobile_number:"6383703693")
    expect(patient.mobile_number.length)==10
    end

    it 'should be not nil ' do
      patient = build(:patient , mobile_number: nil)
      patient.validate
      expect(patient.errors).to include(:mobile_number)

    end
  end
  context "has many appointment" do
    it 'association exists' do
      association = Patient.reflect_on_association(:appointments).macro
      expect(association).to be(:has_many)
    end

  end

  context "has many doc" do
    it "association exists" do
      association = Patient.reflect_on_association(:doctors).macro
      expect(association).to be(:has_many)
    end


  end

end