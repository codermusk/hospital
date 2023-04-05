require 'rails_helper'

RSpec.describe Doctor , type: :model do
  context "name" do
    it "must exists" do
      doctor = build(:doctor , name: nil)
      doctor.validate
      expect(doctor.errors).to include(:name)

    end
    it "must not be nil" do
      doctor = build(:doctor)
      expect(doctor.name).to be_truthy
    end

  end

  context "email" do
    it "must be unique" do
      doctor1 = create(:doctor , email: "doc@gmail.com")
      doctor2= build(:doctor  , email: "doc@gmail.com")
      doctor2.validate
      expect(doctor2.errors).to include(:email)

    end
    it "must has some value" do
      doctor = build(:doctor)
      expect(doctor.email).to be_truthy
    end

    it "must not be nil " do
      doctor = build(:doctor , email: nil)
      doctor.validate
      expect(doctor.errors).to include(:email)
    end



  end
  context "age" do
    it "should be a value" do
    doctor = build(:doctor , age: 23)
    expect(doctor.age).to be >=20
    end

  end
  context "age" do
    it "should not be a string" do
    doctor = build(:doctor , age:"hello")
    doctor.validate
    expect(doctor.errors).to include(:age)
    end
  end


  context "address" do
    it 'should be present' do
      doctor = build(:doctor)
      doctor.validate
      expect(doctor.address).to be_truthy
    end
    it 'should be greater than 15' do
      doctor  = build(:doctor , address: "hello")
      doctor.validate
      expect(doctor.errors).to include(:address)
    end

    it 'should not be nil' do
      doctor = build(:doctor , address: nil)
      doctor.validate
      expect(doctor.errors).to include(:address)
    end

  end
  context "specialization" do
    it 'should not be nil' do
      doctor = build(:doctor , specialization: nil)
      doctor.validate
      expect(doctor.errors).to include(:specialization)

    end

    it "must present" do
      doctor = build(:doctor )
      expect(doctor.specialization).to be_truthy
    end
  end

  context "has many" do

      %i[appointments patients].each do |val|
        it "should have association" do
          association = Doctor.reflect_on_association(val).macro
          expect(association).to be(:has_many)

      end
      end
      it 'rating' do
        association = Doctor.reflect_on_association(:ratings).macro
        expect(association).to be(:has_many)
      end

  end


end