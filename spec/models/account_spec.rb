require 'rails_helper'
RSpec.describe Account , type: :model do
  context "accountable" do
    it 'should exists' do
      account = build :account , accountable: nil
      expect(account.accountable).to be_falsey
    end

  end

  context "email" do
    it 'should not be nil' do
      account = build :account , email: nil
      account.validate
      expect(account.errors).to include(:email)
    end

    it "should be unique" do
      create(:account , email: "myacc@gmail.com")
      account = build :account , email: "myacc@gmail.com"
      expect(account.save).to be_falsey
    end

    it "should be valid " do
      account = build(:account , email: "mymail")
      account.validate
      expect(account.errors).to include(:email)

    end

  end
  context "password" do

    it "should be matching" do
      account = build(:account, password: "123456", password_confirmation: "1234567")
      account.validate

      expect(account.errors).to include(:password_confirmation)
    end

    it "length must be greater than six" do
      account = build(:account, password: "1234", password_confirmation: "1234")
      account.validate

      expect(account.errors).to include(:password)
    end
    it 'should be authenticated' do
      expect(Account).to respond_to(:authenticate!)
    end
  end

  context "belongs to" do
    [:doctor , :patient].each do |val|
      it "#{val}" do
        accountable = create(val)
        create(:account , accountable: accountable)
        expect(Account.where(accountable: accountable)).not_to be_empty
        accountable.destroy
        expect(Account.where(accountable: accountable)).to be_empty
      end
    end
  end
end