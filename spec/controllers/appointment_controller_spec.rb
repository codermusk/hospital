require 'rails_helper'
RSpec.describe Api::AppointmentsController do
  let(:patient){create(:patient)}
  let(:admin_usera){create(:admin_user)}
  let(:doctor){create(:doctor)}
  let(:patient_account){create(:account , accountable: patient)}
  let(:doctor_account){create(:account , accountable: doctor)}
  let(:admin_user_account){create(:account , :accountable => admin_usera)}
  let(:admin_user_token){create(:doorkeeper_access_token , resource_owner_id: admin_user_account.id)}
  let(:patient_token){create(:doorkeeper_access_token , resource_owner_id: patient_account.id)}
  let(:doctor_token){create(:doorkeeper_access_token , resource_owner_id: doctor_account.id)}

  describe "GET/APPOINTMENTS" do
    context "index" do
      it "require authentication" do
        patient = create(:patient)
        get :index , params:{
          patient_id: patient.id
        }
        expect(response).to have_http_status(401)
      end

      it "has patient appointments" do

        get :index , params:{
          patient_id: patient.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "has doctor appointments" do
        get :index , params:{

          access_token: doctor_token.token
        }
        expect(response).to have_http_status(200)
      end


      it "should have valid patient id" do
        get :index , params:{
          patient_id: 0 ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end

      it "admin can access" do
        get :index , params:{

          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end
    end
    context "Show" do
      it "requires authentication" do
        appointment = create(:appointment)
        get :show , params:{
          id: appointment.id
        }
        expect(response).to have_http_status(401)
      end

      it "should be accessed by admin" do
        appointment = create(:appointment)
        get :show , params:{
          id: appointment.id ,
          access_token: admin_user_token.token

        }
        expect(response).to have_http_status(200)
      end

      it "should be accessed by the doctor who has access" do

        appointment = create(:appointment, doctor: doctor)
        get :show , params: {
          id: appointment.id  ,
          doctor_id: doctor.id ,
          access_token: doctor_token.token

        }
        expect(response).to have_http_status(200)


      end

      it "should not be accessed by other doctors " do
        doctor = create(:doctor)
        appointment = create(:appointment, doctor: doctor)
        get :show , params: {
          id: appointment.id  ,
          doctor_id: doctor.id ,
          access_token: doctor_token.token

        }
        expect(response).to have_http_status(403)
      end

      it "should be valid " do
        get :show , params: {
          id: 0,
          doctor_id: doctor.id ,
          access_token: doctor_token.token

        }
        expect(response).to have_http_status(404)
      end

      it "can't be accessed by all patients" do
        patient = create(:patient)
        appointment = create(:appointment  , patient: patient)
        get :show , params: {
          id: appointment.id,
          patient_id: patient.id ,
          access_token: patient_token.token

        }
        expect(response).to have_http_status(403)
      end

      it "can be accessed by that particular patient" do
        appointment = create(:appointment  , patient: patient)
        get :show , params: {
          id: appointment.id,
          patient_id: patient.id ,
          access_token: patient_token.token

        }
        expect(response).to have_http_status(200)
      end
    end
    context "Edit" do
      it "requires authentication" do
        appointment = create(:appointment)
        get :edit , params:{
          id: appointment.id
        }
        expect(response).to have_http_status(401)
      end

      it "should be accessed by admin" do
        appointment = create(:appointment)
        get :edit , params:{
          id: appointment.id ,
          access_token: admin_user_token.token

        }
        expect(response).to have_http_status(200)
      end

      it "should be accessed by the doctor who has access" do

        appointment = create(:appointment, doctor: doctor)
        get :edit , params: {
          id: appointment.id  ,
          doctor_id: doctor.id ,
          access_token: doctor_token.token

        }
        expect(response).to have_http_status(200)


      end

      it "should not be accessed by other doctors " do
        doctor = create(:doctor)
        appointment = create(:appointment, doctor: doctor)
        get :edit, params: {
          id: appointment.id  ,
          doctor_id: doctor.id ,
          access_token: doctor_token.token

        }
        expect(response).to have_http_status(403)
      end

      it "should be valid " do
        get :edit , params: {
          id: 0,
          doctor_id: doctor.id ,
          access_token: doctor_token.token

        }
        expect(response).to have_http_status(404)
      end

      it "can't be accessed by all patients" do
        patient = create(:patient)
        appointment = create(:appointment  , patient: patient)
        get :edit , params: {
          id: appointment.id,
          patient_id: patient.id ,
          access_token: patient_token.token

        }
        expect(response).to have_http_status(403)
      end

      it "can be accessed by that particular patient" do
        appointment = create(:appointment  , patient: patient)
        get :edit , params: {
          id: appointment.id,
          patient_id: patient.id ,
          access_token: patient_token.token

        }
        expect(response).to have_http_status(200)
      end
    end




  end


  describe "PUT/:id/Patients" do
    context "Update" do
      it "requires authentication" do
        appointment = create(:appointment)
        get :update , params:{
          id: appointment.id ,
          appointment: {
            time: "11 Am"
          }
        }
        expect(response).to have_http_status(401)
      end

      it "should be accessed by admin" do
        appointment = create(:appointment)
        get :update , params:{
          id: appointment.id ,
          access_token: admin_user_token.token,
          appointment: {
            time: "11 Am"
          }

        }
        expect(response).to have_http_status(200)
      end

      it "should be accessed by the doctor who has access" do

        appointment = create(:appointment, doctor: doctor)
        get :update , params: {
          id: appointment.id  ,
          doctor_id: doctor.id ,
          access_token: doctor_token.token,
          appointment: {
            time: "11 Am"
          }

        }
        expect(response).to have_http_status(200)


      end

      it "should not be accessed by other doctors " do
        doctor = create(:doctor)
        appointment = create(:appointment, doctor: doctor)
        get :update, params: {
          id: appointment.id  ,
          doctor_id: doctor.id ,
          access_token: doctor_token.token,
          appointment: {
            time: "11 Am"
          }

        }
        expect(response).to have_http_status(403)
      end

      it "should be valid " do
        get :update , params: {
          id: 0,
          doctor_id: doctor.id ,
          access_token: doctor_token.token,
          appointment: {
            time: "11 Am"
          }

        }
        expect(response).to have_http_status(404)
      end

      it "can't be accessed by all patients" do
        patient = create(:patient)
        appointment = create(:appointment  , patient: patient)
        get :update , params: {
          id: appointment.id,
          patient_id: patient.id ,
          access_token: patient_token.token,
          appointment: {
            time: "11 Am"
          }

        }
        expect(response).to have_http_status(403)
      end

      it "can be accessed by that particular patient" do
        appointment = create(:appointment  , patient: patient)
        get :update , params: {
          id: appointment.id,
          patient_id: patient.id ,
          access_token: patient_token.token,
          appointment: {
            time: "11 Am"
          }
        }
        expect(response).to have_http_status(200)
      end
    end

  end
  describe "Delete/Appointment" do
    context "delete" do
      it "requires Authentication" do
        appointment = create(:appointment , patient: patient )
        delete :destroy , params: {
          id: appointment.id ,
          patient_id: patient.id
        }
        expect(response).to have_http_status(401)
      end

      it "can be deleted by the admin" do
        appointment = create(:appointment)
        delete :destroy , params: {
          id: appointment.id ,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "can be deleted by that particular patient" do
        appointment = create(:appointment , patient: patient)
        delete :destroy , params: {
          id: appointment.id ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end


      it "can't be deleted by other patients" do
        patient = create(:patient)
        appointment = create(:appointment , patient: patient)
        delete :destroy , params: {
          id: appointment.id ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end

      it "can be deleted by that doctor" do
        appointment = create(:appointment , doctor: doctor)
        delete :destroy , params: {
          id: appointment.id ,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "can't be deleted by other doctor" do
        doctor = create(:doctor)
        appointment = create(:appointment , doctor: doctor)
        delete :destroy , params: {
          id: appointment.id ,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(403)
      end

    end

  end
end