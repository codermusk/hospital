require 'rails_helper'

RSpec.describe Prescribtion, type: :model do
  describe "tablets" do
    context "given as nil" do
      let(:prescribtion) { build(:prescribtion, tablets: nil) }
      it "shows errors" do
        prescribtion.validate
        expect(prescribtion.errors).to include(:tablets)
      end

      context "given some value" do
        let(:prescribtion) { build(:prescribtion) }
        it 'should have value' do
          expect(prescribtion.tablets).to be_truthy
        end
      end
    end
  end

  describe "comments" do
    context "given as null" do
      let(:prescribtion) { build(:prescribtion, comments: nil) }
      it "should include errors" do
        prescribtion.validate
        expect(prescribtion.errors).to include(:comments)
      end
    end
    context "given text less than len 10" do
      let(:prescribtion) { build(:prescribtion, comments: 'hello') }
      it "should include errors from comments" do
        prescribtion.validate
        expect(prescribtion.errors).to include(:comments)
      end
    end

    context "length more than 10" do
      let(:prescribtion) { create(:prescribtion) }
      it "should be truthy" do
        expect(prescribtion.comments).to be_truthy
      end
    end
  end
  describe "has association" do
    context "Belongs to" do
      it 'appointment' do
        prescribtion = build(:prescribtion)
        expect(prescribtion.appointment).to be_an_instance_of(Appointment)
      end
    end
    context "given as nil" do
      let(:prescribtion){build(:prescribtion , appointment: nil)}
      it "it will be falsey" do
        expect(prescribtion.save).to be_falsey
      end
    end
  end

  context "association" do
    it 'should have one bill' do
      association = Prescribtion.reflect_on_association(:bill).macro
      expect(association).to be(:has_one)

    end

  end
end


