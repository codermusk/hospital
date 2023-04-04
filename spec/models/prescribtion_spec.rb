RSpec.describe Prescribtion , type: :model do
  context "Tablets" do
    it "must not be nil" do
      prescribtion = build(:prescribtion , tablets: nil)
      prescribtion.validate
      expect(prescribtion.errors).to include(:tablets)
    end
    it 'should have value' do
      prescribtion = build(:prescribtion)
      expect(prescribtion.tablets).to be_truthy

    end

  end

  context "fees" do
    it 'should not be nil' do
      prescribtion = build(:prescribtion , fees: nil)
      prescribtion.validate
      expect(prescribtion.errors).to include(:fees)
    end

    it 'should greater than 1000' do
      prescribtion = build(:prescribtion , fees: 100)
      prescribtion.validate
      expect(prescribtion.errors).to include(:fees)
    end
    it 'must be greater than 1000' do
      prescribtion = build :prescribtion , fees: 1000
      expect(prescribtion.fees).to be_truthy
    end

    it "should not be greater than 100000" do
      prescribtion = build(:prescribtion , fees: 10000000000)
      prescribtion.validate
      expect(prescribtion.errors).to include(:fees)
    end

  end
  context "comments" do
    it "should not be nil" do
      prescribtion = build(:prescribtion , comments: nil)
      prescribtion.validate
      expect(prescribtion.errors).to include(:comments)
    end

    it "should be greater than length 10" do
      prescribtion  = build(:prescribtion , comments: "hello")
      prescribtion.validate
      expect(prescribtion.errors).to include(:comments)
    end

    it "should be of length more than 10" do
      prescribtion = build(:prescribtion)
      expect(prescribtion.comments).to be_truthy
    end
  end

  context "Belongs to" do
    it 'appointment' do
      prescribtion = build(:prescribtion)
      expect(prescribtion.appointment).to be_an_instance_of(Appointment)
    end

    it "should not be nil" do
      prescribtion = build(:prescribtion , appointment: nil )
      expect(prescribtion.save).to be_falsey
    end

  end
  context "association" do
    it 'should have one bill' do
      association = Prescribtion.reflect_on_association(:bill).macro
      expect(association).to be(:has_one)

    end

  end
end