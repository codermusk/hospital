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

    end

  end

end