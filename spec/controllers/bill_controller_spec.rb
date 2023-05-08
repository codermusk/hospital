require 'rails_helper'
RSpec.describe Api::BillController do
  let(:patient) { create(:patient) }
  let(:admin_usera) { create(:admin_user) }
  let(:doctor) { create(:doctor) }
  let(:patient_account) { create(:account, accountable: patient) }
  let(:doctor_account) { create(:account, accountable: doctor) }
  let(:admin_user_account) { create(:account, :accountable => admin_usera) }
  let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }
  let(:patient_token) { create(:doorkeeper_access_token, resource_owner_id: patient_account.id) }
  let(:doctor_token) { create(:doorkeeper_access_token, resource_owner_id: doctor_account.id) }
  describe "Get/Bill" do
    context "index" do


    it "requires authentication" do
      get :index
      expect(response ).to have_http_status(401)

    end

    it "can be accessed by admin" do

      get :index , params:{
        access_token: admin_user_token.token
      }
      expect(response).to have_http_status(200)
    end

    it "cant be accessed by doc" do
      get :index , params:{
        access_token: doctor_token.token
      }
      expect(response).to have_http_status(403)
    end
    it "cant be accessed by patient" do
      get :index , params:{
        access_token: patient_token.token
      }
      expect(response).to have_http_status(403)
    end
    end

    context "show" do
      it "requires authentication" do
        bill = create(:bill)
        get :show , params:{
          id: bill.id
        }
        expect(response).to have_http_status(401)
      end

      it "can be  accessed by admin" do
        bill = create(:bill)
        get :show , params:{
          id: bill.id ,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "can be accessed by that patient" do
        appointment = create(:appointment , patient: patient)
        prescribtion = create(:prescribtion , appointment: appointment)
        bill = create(:bill , prescribtion: prescribtion)
        get :show , params:{
          id: bill.id ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "can be accessed by that doctor " do
        appointment = create(:appointment , doctor: doctor)
        prescribtion = create(:prescribtion , appointment: appointment)
        bill = create(:bill , prescribtion: prescribtion)
        get :show , params:{
          id: bill.id ,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "cant be accessed by other doctors " do
        doctor = create(:doctor)
        appointment = create(:appointment , doctor: doctor)
        prescribtion = create(:prescribtion , appointment: appointment)
        bill = create(:bill , prescribtion: prescribtion)
        get :show , params:{
          id: bill.id ,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(403)
      end

      it "cant be accessed by other patients" do
        patient = create(:patient)
        appointment = create(:appointment , patient: patient)
        prescribtion = create(:prescribtion , appointment: appointment)
        bill = create(:bill , prescribtion: prescribtion)
        get :show , params:{
          id: bill.id ,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end


    end


  end

  describe "Put/Bill" do
    context "update" do
      it "requires authentication" do
        bill = create(:bill)
        put :update , params:{
          id: bill.id
        }
        expect(response).to have_http_status(401)
      end
      it "Can be updated by admin" do
        bill = create(:bill)
        put :update , params:{
          id: bill.id ,
          bill:{
            status: 1
          },
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "Can be updated by that doc" do

        appointment = create(:appointment , doctor: doctor)
        prescribtion = create(:prescribtion , appointment: appointment)

        bill = create(:bill, prescribtion: prescribtion)
        put :update , params:{
          id: bill.id ,
          bill:{
            status: 1
          },
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "Cant be updated by that patient" do

        appointment = create(:appointment , patient: patient)
        prescribtion = create(:prescribtion , appointment: appointment)

        bill = create(:bill, prescribtion: prescribtion)
        put :update , params:{
          id: bill.id ,
          bill:{
            status: 1
          },
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end
      it "Cant be updated by other doc" do

        appointment = create(:appointment)
        prescribtion = create(:prescribtion , appointment: appointment)

        bill = create(:bill, prescribtion: prescribtion)
        put :update , params:{
          id: bill.id ,
          bill:{
            status: 1
          },
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(403)
      end
      end
  end
  describe "Delete :id/bill" do
    context "delete" do
      it "requires authentication" do
        bill = create(:bill)
        delete :destroy , params:{
          id:bill.id
        }
        expect(response).to have_http_status(401)
      end
      it "can be deleted by admin" do
        bill = create(:bill)
        delete :destroy , params:{
          id:bill.id,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "can't be deleted by doc" do
        bill = create(:bill)
        delete :destroy , params:{
          id:bill.id,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(403)
      end
      it "can't be deleted by patients" do
        bill = create(:bill)
        delete :destroy , params:{
          id:bill.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(403)
      end

    end

  end
end