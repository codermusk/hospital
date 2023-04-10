require 'rails_helper'
RSpec.describe Api::HospitalsController do

  let(:patient) { create(:patient) }
  let(:admin_usera) { create(:admin_user) }
  let(:doctor) { create(:doctor) }
  let(:patient_account) { create(:account, accountable: patient) }
  let(:doctor_account) { create(:account, accountable: doctor) }
  let(:admin_user_account) { create(:account, :accountable => admin_usera) }
  let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }
  let(:patient_token) { create(:doorkeeper_access_token, resource_owner_id: patient_account.id) }
  let(:doctor_token) { create(:doorkeeper_access_token, resource_owner_id: doctor_account.id) }

  describe 'GET/Hospitals' do
    context "when authorization is not given" do
      it 'remains unauthorized' do
        get :index
        expect(response).to have_http_status(401)
      end
    end
    context "when authorization is given" do
      before() do
        get :index, params: {
          access_token: patient_token.token,
          response: :json

        }
      end
      it 'lists all hospitals' do
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "Post/Hospital" do
    context "when authorization is not given" do
      before() do
        post :create, format: :json
      end
      it 'shows error' do
        expect(response).to have_http_status(401)
      end
    end

    context "when authorization is given" do
      before() do
        post :create, params: {
          access_token: admin_user_token.token,
          hospital: attributes_for(:hospital)
        }
      end
      it 'creates hospital' do
        expect(response).to have_http_status(201)
      end
    end
    context "when not logged in as admin" do
      before() do
        post :create, params: {
          access_token: patient_token.token,
          hospital: attributes_for(:hospital)
        }
      end
      it 'does not allows others to create hospital' do
        expect(response).to have_http_status(401)
      end
    end

    context "logged in as doctor" do
      before() do
        post :create, params: {
          access_token: doctor_token.token,
          hospital: attributes_for(:hospital)
        }
      end
      it 'wont allow doctor to create hospital' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "show/:id/hospitals" do
    context "when authorization is not given" do
      before() do
        hospital = create(:hospital)
        get :show, params: {
          id: hospital.id
        }
        it 'requires authorization' do

          expect(response).to have_http_status(401)
        end
      end
    end
    context "Logged in as patient" do
      before() do
        hospital = create(:hospital)
        get :show, params: {
          access_token: patient_token.token,
          id: hospital.id,
          response: :json
        }
      end
      it 'will show the hospital' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "edit/hospitals" do
    context "when authorization is not provided" do
      before() do
        hospital = create(:hospital)
        get :edit, params: {
          id: hospital.id
        }
      end
      it 'shows unauthorized message' do
        expect(response).to have_http_status(401)
      end
    end

    context "when logged in as admin" do
      before() do
        hospital = create(:hospital)
        get :edit, params: {
          id: hospital.id,
          access_token: admin_user_token.token
        }
      end
      it 'edits the hospital' do
        expect(response).to have_http_status(200)
      end
    end

    context "when logged in as patient" do
      it 'shows unauthorized error message' do
        hospital = create(:hospital)
        get :edit, params: {

          id: hospital.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "update/hospital" do
    context "when authentication is not provided" do
      before() do
        hospital = create(:hospital)
        put :update, params: {
          id: hospital.id,
          # access_token: patient_token.token
        }
      end
      it 'shows error messgae unauthoried' do
        expect(response).to have_http_status(401)
      end
    end

    context "when logged in as admin" do
      before() do
        hospital = create(:hospital)
        hospital.mail = "newmail@gmail.com"
        put :update, params: {
          id: hospital.id,
          access_token: admin_user_token.token,
          hospital: {
            name: 'hospital zzz',
            mail: "adsfads@gmail.com"
          }
        }
      end
      it 'allows only admin to update' do
        expect(response).to have_http_status(201)
      end
    end
    context "when logged in as patient" do
      before() do
        hospital = create(:hospital)
        put :update, params: {
          id: hospital.id,
          access_token: patient_token.token
        }
      end
      it 'shows unauthorized' do
        expect(response).to have_http_status(401)
      end
    end

    context "when logged in as doctor" do
      before() do

        hospital = create(:hospital)
        put :update, params: {
          id: hospital.id,
          access_token: doctor_token.token
        }
      end

      it 'shows unauthorized' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "showHospital/Ratings" do
    context "not logged in" do
      before() do
        hospital = create :hospital
        get :showRatings, params: {
          id: hospital.id
        }
      end
      it "requires authentication" do
        expect(response).to have_http_status(401)
      end
    end

    context "logged in as patient" do
      before() do
        hospital = create :hospital
        get :showRatings, params: {
          id: hospital.id,
          access_token: patient_token.token
        }
      end
      it "lists the ratings of hospital" do
        expect(response).to have_http_status(200)
      end
    end

    context "entered a invalid hos id" do
      before() do
        get :showRatings, params: {
          id: 0,
          access_token: patient_token.token
        }
      end
      it "shows no content error" do
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "delete/hospital" do

    context "when authentication is not provided" do
      before() do
        hospital = create :hospital
        delete :destroy, params: {
          id: hospital.id,

        }
      end
      it 'shows error unauthorized' do
        expect(response).to have_http_status(401)
      end
    end

    context "logged in as admin" do
      before() do
        hospital = create :hospital
        delete :destroy, params: {
          id: hospital.id,
          access_token: admin_user_token.token
        }
      end
      it "shows success message" do
        expect(response).to have_http_status 201
      end
    end

    context "logged in as patient" do
      before() do
        hospital = create :hospital
        delete :destroy, params: {
          id: hospital.id,
          access_token: patient_token.token
        }
      end
      it 'shows unauthorized error message' do
        expect(response).to have_http_status 401
      end
    end

    context "logged in as doctor" do
      before() do
        hospital = create :hospital
        delete :destroy, params: {
          id: hospital.id,
          access_token: doctor_token.token
        }
      end
      it 'shows unauthorized error' do
        expect(response).to have_http_status 401
      end
    end
  end
end

RSpec.describe HospitalsController do
  render_views
  let(:patient) { create(:patient) }
  let(:admin_usera) { create(:admin_user) }
  let(:doctor) { create(:doctor) }
  let(:patient_account) { create(:account, accountable: patient) }
  let(:doctor_account) { create(:account, accountable: doctor) }
  let(:admin_user_account) { create(:account, :accountable => admin_usera) }
  let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }
  let(:patient_token) { create(:doorkeeper_access_token, resource_owner_id: patient_account.id) }
  let(:doctor_token) { create(:doorkeeper_access_token, resource_owner_id: doctor_account.id) }
  describe "Get/Hospitals" do
    context "Index" do
      context "signed as patient" do
        before() do
          sign_in patient_account
          get :index
        end
        it "sends patient to hospital index page" do
          expect(response).to be_truthy
        end
      end

      context "signed in as doctor" do
        it "redirect doctor to appointment path" do
          sign_in doctor_account
          get :index
          expect(response).to redirect_to(doctor_appointments_path(doctor.id))
        end
      end
      context "not logged in" do
        it "does not require authentication" do
          get :index
          expect(response).to be_truthy
        end
      end
      context "logged in as admin" do
        it "allows admin to view " do
          sign_in admin_user_account
          expect(response).to be_truthy
        end
      end
    end
  end
end
