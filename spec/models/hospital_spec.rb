require 'rails_helper'

RSpec.describe Hospital , type: :model do
  context "name" do
    it 'should be of length greater than 5' do
      hospital = FactoryBot.create(:hospital)
      expect(hospital.name.length).to be >=5
    end


  end
end
