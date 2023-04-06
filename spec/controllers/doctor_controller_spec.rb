require 'rails_helper'
RSpec.describe Api::DoctorsController do
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
  describe 'GET/:id/doctors' do
    it 'require authorization' do
      doctor = create(:doctor)
      get :show , params:{
        id: doctor.id

      }
      expect(response).to have_http_status(401)
    end

    it 'does not exist' do
      get :show , params:{
        id: 0,
        access_token: patient_token.token

      }
      expect(response).to have_http_status(404)

    end

    it 'allows to show' do
      doctor1 = create(:doctor)
      get :show , params:{
        id: doctor1.id ,
        access_token: patient_token.token
      }
      expect(response).to have_http_status(200)
    end


    it 'dont allow other doctor to see list of docs' do
      doctor1 = create(:doctor)
      get :show , params:{
        id: doctor1.id ,
        # format: :json,
        access_token: doctor_token.token
      }
      expect(response).to have_http_status(401)
    end

    context "edit" do
      it "requires authorization" do
        doctor = create(:doctor)
        get :edit , params:{
          id: doctor.id
        }
        expect(response).to have_http_status(401)
      end

      it 'wont allow other user to edit' do
        doctor = create(:doctor)
        get :edit , params:{
          id: doctor.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(401)
      end

      it 'allows admin to edit' do
        doctor = create(:doctor)
        get :edit , params:{
          id: doctor.id,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it 'wont allow other doctor to edit' do
        doctor = create(:doctor)
        get :edit , params:{
          id: doctor.id,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(401)

      end

      it "allow current doc to edit" do
        get :edit , params:{
          id: doctor.id,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status 200
      end

    end

    context "update" do
      it "requires authentication" do
        doctor = create(:doctor)
        put :update , params:{
          id: doctor.id ,
          doctor:{
            name: "bharath"
          }

        }
        expect(response).to have_http_status 401

      end

      it "don't allow patient to update" do
        doctor = create(:doctor)
        put :update , params:{
          id: doctor.id ,
          doctor:{
            name: "bharath"
          },
        access_token: patient_token.token
        }
        expect(response).to have_http_status 401
      end
      it 'allows admin to update' do
        doctor = create(:doctor)
        put :update , params:{
          id: doctor.id ,
          doctor:{
            name: "bharath"
          },
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(201)
      end

      it 'wont allow different doctor to update' do
        doctor = create(:doctor)
        put :update , params:{
          id: doctor.id ,
          doctor:{
            name: "bharath"
          },
          access_token: doctor_token.token
        }

        expect(response).to have_http_status 401

      end

      it 'allow current doctor to update' do
        put :update , params:{
          id: doctor.id ,
          doctor:{
            name: "bharath"
          },
          access_token: doctor_token.token
        }

        expect(response).to have_http_status 201

      end

      it 'must be a valid id' do
        put :update , params:{
          id: 0 ,
          doctor:{
            name: "bharath"
          },
          access_token: doctor_token.token
        }

        expect(response).to have_http_status 404
      end
    end
  end
  describe "Delete/:id/Hospital" do
    it 'requires authorization' do
      doctor = create(:doctor)
      delete :destroy , params:{
        id: doctor.id
      }
      expect(response).to have_http_status 401

    end
    it "allows admin to destroy" do
      doctor = create(:doctor)
      delete :destroy , params:{
        id: doctor.id,
        access_token: admin_user_token.token
      }
      expect(response).to have_http_status 201

    end

    it "must be a valid id" do
      delete :destroy , params:{
        id: 0 ,
        access_token: admin_user_token.token
      }
      expect(response).to have_http_status 404
    end

    it "wont allow patients to delete" do
      doctor = create(:doctor)
      delete :destroy , params:{
        id: doctor.id ,
        access_token: patient_token.token
      }
      expect(response).to have_http_status 401
    end

    it "wont allow other doctor to delete" do
      doctor = create(:doctor)
      delete :destroy , params:{
        id: doctor.id ,
        access_token: doctor_token.token
      }
      expect(response).to have_http_status 401
    end
    it " wont allow current doctor to destroy" do

      delete :destroy , params:{
        id: doctor.id ,
        access_token: patient_token.token
      }
      expect(response).to have_http_status 401
    end
  end

end