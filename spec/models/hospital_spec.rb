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
  end
  context "mail" do
    it 'should not be null ' do
      hospital = build(:hospital)
      expect(hospital.mail).to be_truthy
    end

  end
  context "address" do
    it "should greater than 20 " do
      hospital = build(:hospital)
      expect(hospital.address.length).to be >=20
    end

  end

  context "" do

  end
end
