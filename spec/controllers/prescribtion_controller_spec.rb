require 'rails_helper'
RSpec.describe Api::PrescribtionsController do
  let(:patient) { create(:patient) }
  let(:admin_usera) { create(:admin_user) }
  let(:doctor) { create(:doctor) }
  let(:patient_account) { create(:account, accountable: patient) }
  let(:doctor_account) { create(:account, accountable: doctor) }
  let(:admin_user_account) { create(:account, :accountable => admin_usera) }
  let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }
  let(:patient_token) { create(:doorkeeper_access_token, resource_owner_id: patient_account.id) }
  let(:doctor_token) { create(:doorkeeper_access_token, resource_owner_id: doctor_account.id) }

  describe "GET/Prescribtions" do
    context "index" do
      it 'requires authentication' do

        get :index
        expect(response).to have_http_status(401)

      end
      it 'can be accessed by adminuser' do

        get :index, params: {
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it 'cant be accessed by doctors' do
        get :index, params: {
          access_token: doctor_token.token
        }

        expect(response).to have_http_status(403)
      end

      it 'cant be accessed by patient' do
        get :index, params: {
          access_token: patient_token.token
        }

        expect(response).to have_http_status(403)
      end
    end

    context "show" do
      it 'requires authentication' do
        prescribtion = create(:prescribtion)
        get :show, params: {
          id: prescribtion.id
        }
        expect(response).to have_http_status(401)
      end

      it 'can be accessed by admin user' do
        prescribtion = create(:prescribtion)
        get :show, params: {
          id: prescribtion.id,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "can be accessed by that patient" do
        appointment = create(:appointment, patient: patient)
        prescribtion = create(:prescribtion, appointment: appointment)
        get :show, params: {
          id: prescribtion.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "can be accessed by that doctor" do
        appointment = create(:appointment, doctor: doctor)
        prescribtion = create(:prescribtion, appointment: appointment)
        get :show, params: {
          id: prescribtion.id,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "cant be accessed by other doctor" do
        prescribtion = create(:prescribtion)
        get :show, params: {
          id: prescribtion.id,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(403)
      end
      it "cant be accessed by other patients" do
        prescribtion = create(:prescribtion)
        get :show, params: {
          id: prescribtion.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end

    end
    context "edit" do
      it 'requires authentication' do
        prescribtion = create(:prescribtion)
        get :edit, params: {
          id: prescribtion.id,
          appointment_id: prescribtion.appointment_id
        }
        expect(response).to have_http_status(401)
      end

      it 'can be accessed by admin user' do
        prescribtion = create(:prescribtion)
        get :edit, params: {
          id: prescribtion.id,
          access_token: admin_user_token.token,
          appointment_id: prescribtion.appointment_id
        }
        expect(response).to have_http_status(200)
      end

      it "cant be accessed by that patient" do
        appointment = create(:appointment, patient: patient)
        prescribtion = create(:prescribtion, appointment: appointment)
        get :edit, params: {
          id: prescribtion.id,
          access_token: patient_token.token,
          appointment_id: prescribtion.appointment_id
        }
        expect(response).to have_http_status(403)
      end
      it "can be accessed by that doctor" do
        appointment = create(:appointment, doctor: doctor)
        prescribtion = create(:prescribtion, appointment: appointment)
        get :edit, params: {
          id: prescribtion.id,
          access_token: doctor_token.token,
          appointment_id: prescribtion.appointment_id
        }
        expect(response).to have_http_status(200)
      end

      it "cant be accessed by other doctor" do
        prescribtion = create(:prescribtion)
        get :edit, params: {
          id: prescribtion.id,
          access_token: doctor_token.token,
          appointment_id: prescribtion.appointment_id
        }
        expect(response).to have_http_status(403)
      end
      it "cant be accessed by other patients" do
        prescribtion = create(:prescribtion)
        get :edit, params: {
          id: prescribtion.id,
          access_token: patient_token.token,
          appointment_id: prescribtion.appointment_id
        }
        expect(response).to have_http_status 403
      end

    end

  end

  describe "Put/:id/Prescribtion" do
    it "requires authentication" do
      prescribtion = create(:prescribtion)
      put :update, params: {
        id: prescribtion.id,
        prescribtion: {
          fees: 1300
        }
      }
      expect(response).to have_http_status(401)
    end

    it "can be updated by the admin" do
      prescribtion = create(:prescribtion)
      put :update, params: {
        id: prescribtion.id,
        access_token: admin_user_token.token,
        prescribtion: {
          fees: 1300
        }
      }
      expect(response).to have_http_status(201)
    end

    it "cant be edited by that patient " do
      appointment = create(:appointment, patient: patient)
      prescribtion = create(:prescribtion, appointment: appointment)
      get :update, params: {
        id: prescribtion.id,
        access_token: patient_token.token,
        prescribtion: {
          fees: 1300
        }

      }
      expect(response).to have_http_status(403)
    end

    it "cant be accessed by any of the patients " do
      patient = create(:patient)
      appointment = create(:appointment, patient: patient)
      prescribtion = create(:prescribtion, appointment: appointment)
      get :update, params: {
        id: prescribtion.id,
        access_token: patient_token.token,
        prescribtion: {
          fees: 1300
        }

      }
      expect(response).to have_http_status(403)
    end

    it "can be updated by that doctor" do
      appointment = create(:appointment, doctor: doctor)
      prescribtion = create(:prescribtion, appointment: appointment)
      put :update, params: {
        id: prescribtion.id,
        access_token: doctor_token.token,
        prescribtion: {
          fees: 1300
        }
      }
      expect(response).to have_http_status(201)
    end

    it "cant be accessed by other doctors " do
      prescribtion = create(:prescribtion)
      put :update, params: {
        id: prescribtion.id,
        access_token: doctor_token.token,
        prescribtion: {
          fees: 1300
        }
      }
      expect(response).to have_http_status(403)
    end
  end

  describe "Delete :id/prescribtions" do
    it "requires authentication" do
      prescribtion = create(:prescribtion)
      delete :destroy, params: {
        id: prescribtion.id
      }
      expect(response).to have_http_status(401)
    end

    it "can be deleted by admin" do
      prescribtion = create(:prescribtion)
      delete :destroy, params: {
        id: prescribtion.id,
        access_token: admin_user_token.token
      }
      expect(response).to have_http_status(200)
    end

    it "cant be deleted by any of the doctors" do
      appointment = create(:appointment, doctor: doctor)
      prescribtion = create(:prescribtion, appointment: appointment)
      delete :destroy, params: {
        id: prescribtion.id,
        access_token: doctor_token.token,

      }
      expect(response).to have_http_status(403)
    end

    it "cant be deleted by any of the patients" do
      prescribtion = create(:prescribtion)
      delete :destroy, params: {
        id: prescribtion.id,
        access_token: patient_token.token,

      }
      expect(response).to have_http_status(403)
    end

  end
end

RSpec.describe PrescribtionsController do
  let(:patient) { create(:patient) }
  let(:admin_usera) { create(:admin_user) }
  let(:doctor) { create(:doctor) }
  let(:patient_account) { create(:account, accountable: patient) }
  let(:doctor_account) { create(:account, accountable: doctor) }
  let(:admin_user_account) { create(:account, :accountable => admin_usera) }
  let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }
  let(:patient_token) { create(:doorkeeper_access_token, resource_owner_id: patient_account.id) }
  let(:doctor_token) { create(:doorkeeper_access_token, resource_owner_id: doctor_account.id) }
  render_views
  describe "get/new" do
    context "trying to access new prescribtion page without auth" do
      it "redirects to the index page" do
        appointment = create(:appointment)
        get :new, params: {
          appointment_id: appointment.id
        }
        expect(response).to redirect_to(hospitals_path)
      end
    end
    context "if logged in as a doctor" do
      it "renders the view page" do
        appointment = create(:appointment)
        sign_in doctor_account
        get :new, params: {
          appointment_id: appointment.id
        }
        expect(response).to render_template :new
      end
    end
    context "if logged in as a patient" do
      it "redirects to the index page" do
        appointment = create(:appointment)
        sign_in patient_account
        get :new, params: {
          appointment_id: appointment.id
        }
        expect(response).to redirect_to(hospitals_path)
      end
    end
  end
  describe "post/prescribtion" do
    context "creating new prescribtion  without authentication " do
      it "render new" do
        prescribtion = create(:prescribtion)
        appointment = create(:appointment)
        post :create, params: {
          appointment_id: appointment.id,
          prescribtion: prescribtion
        }
        expect(response).to render_template :new
      end

      it "throws an error" do
        prescribtion = create(:prescribtion)
        appointment = create(:appointment)
        post :create, params: {
          appointment_id: appointment.id,
          prescribtion: prescribtion
        }
        expect(response).to have_http_status(401)
      end
    end
    context "when logged in as a doctor" do

      it "can be created" do
        sign_in doctor_account
        pres_params = attributes_for(:prescribtion)
        bill_params = attributes_for(:bill)
        appointment = create(:appointment)
        post :create, params: {
          appointment_id: appointment.id,
          prescribtion: pres_params,
          bill_attributes: bill_params

        }

        expect(flash[:notice]).to eq("prescribed SuccessFully")
      end

      it "redirects to doctors appointment path" do
        sign_in doctor_account
        pres_params = attributes_for(:prescribtion)
        bill_params = attributes_for(:bill)
        appointment = create(:appointment)
        post :create, params: {
          appointment_id: appointment.id,
          prescribtion: pres_params,
          bill_attributes: bill_params

        }
        expect(response).to redirect_to(doctor_appointments_path(doctor_account.accountable_id))
      end
    end

  end

  describe "get/prescribtion" do
    context "signed in as a patient" do
      it "shows his prescribtion" do
        sign_in patient_account
        prescribtion = create(:prescribtion)
        get :show, params: {
          id: prescribtion.id
        }
        expect(response).to be_truthy
      end
    end
    context "not signed in" do
      it "redireects to hospital path" do
        prescribtion = create(:prescribtion)
        get :show, params: {
          id: prescribtion.id
        }
        expect(response).to redirect_to hospitals_path
      end
    end
  end
  describe "get/edit" do
    context "signed in as a doctor" do
      it "render edit page" do
        sign_in doctor_account
        prescribtion = create(:prescribtion)
        get :edit, params: {
          id: prescribtion.id
        }
        expect(response).to render_template :edit
      end
    end
    context "not signed in" do
      it "redirects to hospital path" do

        prescribtion = create(:prescribtion)
        get :edit, params: {
          id: prescribtion.id
        }
        expect(response).to redirect_to hospitals_path

      end
    end
  end

  describe "put/update" do
    context "signed in as a patient" do
      it "redirects to hospital path with a notice" do
        sign_in patient_account
        prescribtion = create(:prescribtion)
        put :update , params:{
          id: prescribtion.id ,
          prescribtion:{
            fees: 2300
          }
        }
        expect(response).to redirect_to hospitals_path
        expect(flash[:notice]).to eq("Not Allowed")
      end


    end
    context "signed in as a doctor" do
      it "updated and shows a notice" do
        sign_in doctor_account
        prescribtion = create(:prescribtion)
        put :update , params:{
          id: prescribtion.id ,
          prescribtion:{
            fees: 2300
          }
        }
        expect(response).to redirect_to doctor_appointments_path(doctor_account.accountable_id)
        expect(flash[:notice]).to eq("Prescription Updated")
      end
    end
  end
end