RSpec.describe Bill , type: :model do
  context "doctor_fees" do
    it 'should not be nil' do
      bill = build(:bill , doctor_fees: nil)
      bill.validate
      expect(bill.errors).to include(:doctor_fees)
    end
    it 'should be greater than 999' do
      bill = build(:bill , doctor_fees: 999)
      bill.validate
      expect(bill.errors).to include(:doctor_fees)

    end

    it 'should be less than 1lac' do
      bill = build(:bill , doctor_fees: 10000000)
      bill.validate
      expect(bill.errors).to include(:doctor_fees)
    end

    it 'should be a number' do
      bill = build(:bill , doctor_fees: 1000)
      expect(bill.doctor_fees).to be_truthy
    end

  end

  context "status" do
    it 'should be a boolean' do
      bill = build(:bill , status: true)
      expect(bill.status).to be_in([true , false])
    end

  end

  context "belongs to" do
    it "prescribtion" do
      bill = build(:bill , prescribtion: nil)

      expect(bill.save).to be_falsey
    end

    it "one prescribtion" do
      bill = build(:bill)
      expect(bill.save).to be_truthy
    end

  end

end