require 'rails_helper'
RSpec.describe Api::HospitalsController do
  let(:patient){create(:patient)}
  let(:admin_usera){create(:admin_user)}
  let(:doctor){create(:doctor)}
  let(:patient_account){create(:account , accountable: patient)}
  let(:doctor_account){create(:account , accountable: doctor)}
  let(:admin_user_account){create(:account , :accountable => admin_usera)}
  let(:admin_user_token){create(:doorkeeper_access_token , resource_owner_id: admin_user_account.id)}
  let(:patient_token){create(:doorkeeper_access_token , resource_owner_id: patient_account.id)}
  let(:doctor_token){create(:doorkeeper_access_token , resource_owner_id: doctor_account.id)}
  describe "GET/hospitals/:hos_id/doctors" do
    it "requires hospital id" do
      hospital = create(:hospital)
      doctor = build(:doctor )
      hospital.doctors << doctor

      get :index , params:{
        access_token: admin_user_token.token ,
        hospital_id: hospital.id
      }
      expect(response).to have_http_status(200)
    end

    it 'requires authentication' do
      hospital = create(:hospital)
      doctor = build(:doctor )
      hospital.doctors << doctor

      get :index , params:{

        hospital_id: hospital.id
      }
      expect(response).to have_http_status(401)
    end

  end


end