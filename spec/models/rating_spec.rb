RSpec.describe Rating , type: :model do
  context "rating" do
    it 'should be less than or equal to 10' do
      rating = build(:rating)
      expect(rating.rating).to be <11

    end

    it 'should be greater than 0' do
      rating  = build(:rating)
      expect(rating.rating).to be >0
    end


    it 'should not be nil' do
      rating = build(:rating , rating: nil )
      rating.validate
      expect(rating.errors).to include(:rating)
    end

  end

  context 'checks' do
    it 'doctor' do
      doctor = create(:doctor)
      rating = create(:rating , ratable: doctor)
      expect(rating.ratable).to be_an_instance_of(Doctor)
      expect(rating.ratable).not_to be_an_instance_of(Hospital)


    end
    it 'hospital' do
      hospital = create(:hospital)
      rating = create(:rating , ratable: hospital)
      expect(rating.ratable).to be_an_instance_of(Hospital)
      expect(rating.ratable).not_to be_an_instance_of(Doctor)

    end

    it 'Ratable_type' do
      rating = create(:rating , :for_hospital)
      expect(rating.ratable_type).to eq("Hospital")
    end

    it 'ratable_doc' do
      rating = create(:rating , :for_doctor)
      expect(rating.ratable_type).to eq("Doctor")
    end

  end

  context "ratable " do
    it 'should not be nil' do
      rating = build(:rating , ratable: nil )
      rating.validate
      expect(rating.errors).to include(:ratable)
    end

  end

  context "review" do
    it 'should not be nil' do
      rating = build(:rating , review: nil)
      expect(rating.review).to be_falsey
    end
    it 'should be present' do
      rating = build :rating , review: "I found out last night that Jethro had put a letter in the mailbox for me but I was too late to pick"
      rating.validate
      expect(rating.review).to be_truthy
    end

  end

  context "patient" do
    it 'should have association' do
      rating = build(:rating)
      expect(rating.patient).to be_an_instance_of(Patient)
    end

    it 'should not be nil' do
      rating = build(:rating , patient: nil)
      rating.validate
      expect(rating.errors).to include(:patient)
    end

  end
end