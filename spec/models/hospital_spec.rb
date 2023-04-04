require 'rails_helper'

RSpec.describe Hospital , type: :model do
  context "name" do
    it 'should be of length greater than 5' do
      hospital = build(:hospital)
      expect(hospital.name.length).to be >=5
    end
    it "should not greater than 20" do
      hospital = build(:hospital)
      expect(hospital.name.length).to be <=20
    end
    it "should greater than 5 " do
      hospital = build(:hospital , name: "hai")
      hospital.validate
      expect(hospital.errors).to include(:name)
    end

    it "should less than 20" do
      hospital = build(:hospital  , name: "this is my hospital and this is my hospital")
      hospital.validate
      expect(hospital.errors).to include(:name)

    end
  end
  context "mail" do
    it 'should not be null ' do
      hospital = build(:hospital)
      expect(hospital.mail).to be_truthy
    end
    it "must exist" do
      hospital = build(:hospital , mail: nil)
      hospital.validate
      expect(hospital.errors).to include(:mail)
    end

    it "should be unique" do
      hospital1 = create(:hospital , mail: "myhosp@gmail.com")
      hospital2 = build(:hospital , mail:"myhosp@gmail.com")
      hospital2.validate
      expect(hospital2.errors).to include(:mail)
    end
  end
  context "address" do
    it "should greater than 15 " do
      hospital = build(:hospital)
      expect(hospital.address.length).to be >=15
    end
    it "should not greater than 50" do
      hospital = build(:hospital)
      expect(hospital.address.length).to be<=50
    end

    it "must greater than 15" do
      hospital = build(:hospital , address: "this add")
      hospital.validate
      expect(hospital.errors).to include(:address)
    end

    it "must less than 50" do
      hospital = build(:hospital , address: "This is the hospital which is present in this place and this hospital has more than 50 characters adn length is more than 50")
      hospital.validate
      expect(hospital.errors).to include(:address)
    end

  end


end
