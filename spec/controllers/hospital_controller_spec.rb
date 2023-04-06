require 'rails_helper'
RSpec.describe Api::HospitalsController  do

  let(:patient){create(:patient)}
  let(:admin_usera){create(:admin_user)}
  let(:doctor){create(:doctor)}
  let(:patient_account){create(:account , accountable: patient)}
  let(:doctor_account){create(:account , accountable: doctor)}
  let(:admin_user_account){create(:account , :accountable => admin_usera)}
  let(:admin_user_token){create(:doorkeeper_access_token , resource_owner_id: admin_user_account.id)}
  let(:patient_token){create(:doorkeeper_access_token , resource_owner_id: patient_account.id)}
  let(:doctor_token){create(:doorkeeper_access_token , resource_owner_id: doctor_account.id)}



  describe 'GET/Hospitals' do
    it 'remains unauthorized' do
      get :index
      expect(response).to have_http_status(401)
    end

    it 'lists all hospitals' do
      get :index , params: {
        access_token: patient_token.token ,
        response: :json

      }
      expect(response).to have_http_status(200)
    end

  end

  describe "Post/Hospital" do
    it 'requires authentication' do
      post :create , format: :json
      expect(response).to have_http_status(401)
    end

    it 'creates hospital' do
      post :create , params:{
        access_token: admin_user_token.token ,
        hospital: attributes_for(:hospital)
      }
      expect(response).to have_http_status(201)
    end

    it 'does not allows others to create hospital' do
      post :create , params:{
        access_token: patient_token.token ,
        hospital: attributes_for(:hospital)
      }
      expect(response).to have_http_status(401)
    end


    it 'wont allow doctor to create hospital' do
      post :create , params:{
        access_token: doctor_token.token ,
        hospital: attributes_for(:hospital)
      }
      expect(response).to have_http_status(401)

    end

  end


  describe "show/:id/hospitals" do

    it 'requires authorization' do
      hospital = create(:hospital)
      get :show , params:{
        id:  hospital.id
      }
      expect(response).to have_http_status(401)
    end
    it 'will show the hospital' do
      hospital = create(:hospital)
      get :show , params:{
        access_token: patient_token.token ,
        id: hospital.id,
      response: :json
      }
      expect(response).to have_http_status(200)
    end

  end

  describe "edit/hospitals" do
    it 'requires authentication' do
      hospital = create(:hospital)
      get :edit , params:{
        id: hospital.id
      }
      expect(response).to have_http_status(401)
    end

    it 'edit the hospital' do
      hospital = create(:hospital)
      get :edit , params:{
        id: hospital.id,
      access_token: admin_user_token.token
      }
      expect(response).to have_http_status(200)
    end

    it 'does not allow others to edit' do
      hospital = create(:hospital)
      get :edit , params:{

        id: hospital.id,
        access_token: patient_token.token
      }
      expect(response).to have_http_status(401)
    end

  end

  describe "update/hospital" do
    it 'requires authorization' do
      hospital = create(:hospital)
      put :update , params:{
        id: hospital.id,
        # access_token: patient_token.token
      }
      expect(response).to have_http_status(401)
    end

    it  'allows only admin to update' do
      hospital = create(:hospital)
      hospital.mail = "newmail@gmail.com"
      put :update , params:{
        id: hospital.id,
        access_token: admin_user_token.token,
        hospital: {
          name: 'hospital zzz',
          mail: "adsfads@gmail.com"
        }
      }
      expect(response).to have_http_status(201)
    end

    it 'dont allow patient to update' do
      hospital = create(:hospital)
      put :update , params:{
        id: hospital.id,
        access_token: patient_token.token
      }
      expect(response).to have_http_status(401)
    end

    it 'dont allow doctor to update' do
      hospital = create(:hospital)
      put :update , params:{
        id: hospital.id,
        access_token: doctor_token.token
      }
      expect(response).to have_http_status(401)
    end

  end

  describe "delete/hospital" do
    it 'requires authorization' do
      hospital = create :hospital
      delete :destroy , params:{
        id: hospital.id,

      }
      expect(response).to have_http_status(401)
    end

    it "allows admin to delete not others" do
      hospital = create :hospital
      delete :destroy , params:{
        id: hospital.id,
        access_token: admin_user_token.token
      }
      expect(response).to have_http_status 201
    end

    it 'wont allow others to delete' do
      hospital = create :hospital
      delete :destroy , params:{
        id: hospital.id,
        access_token: patient_token.token
      }
      expect(response).to have_http_status 401
    end

    it 'wont allow to destroy by other' do
      hospital = create :hospital
      delete :destroy , params:{
        id: hospital.id,
        access_token: doctor_token.token
      }
      expect(response).to have_http_status 401
    end

  end
end