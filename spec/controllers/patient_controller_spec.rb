require 'rails_helper'

RSpec.describe Api::PatientsController do
  let(:patient){create(:patient)}
  let(:admin_usera){create(:admin_user)}
  let(:doctor){create(:doctor)}
  let(:patient_account){create(:account , accountable: patient)}
  let(:doctor_account){create(:account , accountable: doctor)}
  let(:admin_user_account){create(:account , :accountable => admin_usera)}
  let(:admin_user_token){create(:doorkeeper_access_token , resource_owner_id: admin_user_account.id)}
  let(:patient_token){create(:doorkeeper_access_token , resource_owner_id: patient_account.id)}
  let(:doctor_token){create(:doorkeeper_access_token , resource_owner_id: doctor_account.id)}
  describe "Get/Patients" do
    context "Index" do
      it "Requires Authorization" do
        get :index
        expect(response).to have_http_status(401)
      end

      it "must be a admin" do
        get :index , params:{
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)

      end

      it "wont allow doctor to see" do
        get :index , params:{
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(403)
      end

      it "wont allow patient to see" do
        get :index , params:{
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end

    end

    context "show" do

      it "Requires Authorization" do
        patient = create(:patient)
        get :show , params:{
          id: patient.id
        }
        expect(response).to have_http_status(401)
      end

      it "wont allow doctor" do
        patient = create(:patient)
        get :show , params:{
          id: patient.id ,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(403)

      end

      it "allow admin to view" do
        patient = create(:patient)
        get :show , params:{
          id: patient.id ,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "allow patient to view" do

        get :show , params:{
          id: patient.id ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "wont allow other patient to view" do
        patient = create(:patient)
        get :show , params:{
          id: patient.id ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end
    end
    context "edit" do

      it "Requires Authorization" do
        patient = create(:patient)
        get :edit , params:{
          id: patient.id
        }
        expect(response).to have_http_status(401)
      end

      it "wont allow doctor" do
        patient = create(:patient)
        get :edit , params:{
          id: patient.id ,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(401)

      end

      it "allow admin to edit" do
        patient = create(:patient)
        get :edit , params:{
          id: patient.id ,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "allow patient to edit" do

        get :edit, params:{
          id: patient.id ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "wont allow other patient to edit" do
        patient = create(:patient)
        get :edit , params:{
          id: patient.id ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(401)
      end
    end



  end

  describe  "Put :id/Patients" do
    context "update" do
      it "Requires Authorization" do
        patient = create(:patient)
        put :update , params:{
          id: patient.id,
        patient:{
          name: "bharath"
        }
        }
        expect(response).to have_http_status(401)
      end

      it "cant done by a doctor" do
        patient = create(:patient)
        put :update , params:{
          id: patient.id,
          patient:{
            name: "bharath" ,
            access_token: doctor_token.token
          }
        }
        expect(response).to have_http_status(401)
      end


      it "can be edited by a admin" do
        patient = create(:patient)
        put :update , params:{
          id: patient.id,
          patient:{
            name: "bharath"

          },
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "can be edited by that patient" do

        put :update , params:{
          id: patient.id,
          patient:{
            name: "bharath"

          },
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "can't be edited by other patients" do
        patient = create(:patient)
        put :update , params:{
          id: patient.id,
          patient:{
            name: "bharath"

          },
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end

      it "should be a valid id" do
        put :update , params:{
          id: 0,
          patient:{
            name: "bharath"

          },
          access_token: patient_token.token
        }
        expect(response).to have_http_status(404)
      end

    end
  end

  describe "Delete :id/Patients" do
    it 'require authorization' do
      delete :destroy , params:{
        id: patient.id
      }
      expect(response).to have_http_status(401)
    end
    it "cant done by a doctor" do
      patient = create(:patient)
      delete :destroy  , params:{
        id: patient.id,
        access_token: doctor_token.token

      }
      expect(response).to have_http_status(403)
    end


    it "can be edited by a admin" do
      patient = create(:patient)
      delete :destroy , params:{
        id: patient.id,
        access_token: admin_user_token.token
      }
      expect(response).to have_http_status(200)
    end
    it "can be edited by that patient" do

      delete :destroy , params:{
        id: patient.id,
        access_token: patient_token.token
      }
      expect(response).to have_http_status(200)
    end
    it "can't be deleted by other patients" do
      patient = create(:patient)
      delete :destroy , params:{
        id: patient.id,
        access_token: patient_token.token
      }
      expect(response).to have_http_status(403)
    end

    it "should be a valid id" do
      delete :destroy , params:{
        id: 0,

        access_token: patient_token.token
      }
      expect(response).to have_http_status(404)
    end
  end
end