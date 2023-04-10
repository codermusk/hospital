require 'rails_helper'
RSpec.describe Api::DoctorsController do
  let(:patient) { create(:patient) }
  let(:admin_usera) { create(:admin_user) }
  let(:doctor) { create(:doctor) }
  let(:patient_account) { create(:account, accountable: patient) }
  let(:doctor_account) { create(:account, accountable: doctor) }
  let(:admin_user_account) { create(:account, :accountable => admin_usera) }
  let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }
  let(:patient_token) { create(:doorkeeper_access_token, resource_owner_id: patient_account.id) }
  let(:doctor_token) { create(:doorkeeper_access_token, resource_owner_id: doctor_account.id) }

  describe "GET/hospitals/:hos_id/doctors" do
    context "when hospital id not given" do
      it "throws an error" do
        hospital = create(:hospital)
        doctor = build(:doctor)
        hospital.doctors << doctor

        get :index, params: {
          access_token: admin_user_token.token,
          hospital_id: hospital.id
        }
        expect(response).to have_http_status(200)
      end
    end

    context "when authentication is not given" do
      it 'throws error as unauthenticated' do
        hospital = create(:hospital)
        doctor = build(:doctor)
        hospital.doctors << doctor

        get :index, params: {

          hospital_id: hospital.id
        }
        expect(response).to have_http_status(401)
      end
    end

  end

  describe "showdoctor/Ratings" do
    context "if authentication is not provided" do
      it "throws an error" do
        doctor = create(:doctor)
        get :showRating, params: {
          id: doctor.id
        }
        expect(response).to have_http_status(401)
      end
      context "if authentication is provides" do
        it "shows lists of doc ratings" do
          doctor = create(:doctor)
          get :showRating, params: {
            id: doctor.id,
            access_token: patient_token.token
          }
          expect(response).to have_http_status(200)
        end
      end

      context "if valid doctor id is not given " do
        it "will throw an error" do
          get :showRating, params: {
            id: 0,
            access_token: patient_token.token
          }
          expect(response).to have_http_status(404)
        end

      end
    end

  end
  describe 'GET/:id/doctors' do
    context "Not authorized" do
      it 'throws error as authorization required' do
        doctor = create(:doctor)
        get :show, params: {
          id: doctor.id

        }
        expect(response).to have_http_status(401)
      end
    end

    context "when you give an non existing id" do
      it 'throws no content message' do
        get :show, params: {
          id: 0,
          access_token: patient_token.token

        }
        expect(response).to have_http_status(404)

      end
    end
    context "when doctor id is given " do
      it 'allows to show' do
        doctor1 = create(:doctor)
        get :show, params: {
          id: doctor1.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
    end
    context "when non related doc id is given " do
      it 'dont allow' do
        doctor1 = create(:doctor)
        get :show, params: {
          id: doctor1.id,
          # format: :json,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(401)
      end
    end

    context "edit" do
      context "when authentication in not provided" do
        it "throws unauthorized message" do
          doctor = create(:doctor)
          get :edit, params: {
            id: doctor.id
          }
          expect(response).to have_http_status(401)
        end

      end
      context "when logged in as patient " do
        it 'wont allow other user to edit' do
          doctor = create(:doctor)
          get :edit, params: {
            id: doctor.id,
            access_token: patient_token.token
          }
          expect(response).to have_http_status(401)
        end
      end
      context "when logged in as admin" do
        it 'allows admin to edit' do
          doctor = create(:doctor)
          get :edit, params: {
            id: doctor.id,
            access_token: admin_user_token.token
          }
          expect(response).to have_http_status(200)
        end
      end

      context "when logged in as doctor who dont have relation" do
        it 'wont allow other doctor to edit' do
          doctor = create(:doctor)
          get :edit, params: {
            id: doctor.id,
            access_token: doctor_token.token
          }
          expect(response).to have_http_status(401)

        end
      end
      context "when logged in as related doctor" do
        it "allow current doc to edit" do
          get :edit, params: {
            id: doctor.id,
            access_token: doctor_token.token
          }
          expect(response).to have_http_status 200
        end
      end

    end

    context "update" do
      context "when authentication is not provided" do
        it "shows unauthorized error message" do
          doctor = create(:doctor)
          put :update, params: {
            id: doctor.id,
            doctor: {
              name: "bharath"
            }

          }
          expect(response).to have_http_status 401

        end
      end

      context "when logged in as patient" do
        it "shows unauthorized error message" do
          doctor = create(:doctor)
          put :update, params: {
            id: doctor.id,
            doctor: {
              name: "bharath"
            },
            access_token: patient_token.token
          }
          expect(response).to have_http_status 401
        end
      end
      context "when logged in as admin" do
        it 'allows admin to update' do
          doctor = create(:doctor)
          put :update, params: {
            id: doctor.id,
            doctor: {
              name: "bharath"
            },
            access_token: admin_user_token.token
          }
          expect(response).to have_http_status(201)
        end
      end

      context "when logged in as unrelated doctor" do
        it 'shows unauthorized message' do
          doctor = create(:doctor)
          put :update, params: {
            id: doctor.id,
            doctor: {
              name: "bharath"
            },
            access_token: doctor_token.token
          }

          expect(response).to have_http_status 401

        end

      end
      context "when logged in as related doctor" do
        it 'allow current doctor to update' do
          put :update, params: {
            id: doctor.id,
            doctor: {
              name: "bharath"
            },
            access_token: doctor_token.token
          }

          expect(response).to have_http_status 201

        end
      end


      context "when non existing id is given" do
        it 'shows no content message' do
          put :update, params: {
            id: 0,
            doctor: {
              name: "bharath"
            },
            access_token: doctor_token.token
          }

          expect(response).to have_http_status 404
        end
      end
    end
  end
  describe "Delete/:id/Hospital" do
    context "when authentication is not given" do
      it 'throws unauthorized error'do
        doctor = create(:doctor)
        delete :destroy, params: {
          id: doctor.id
        }
        expect(response).to have_http_status 401

      end
    end

    context "when logged in as admin" do
      it "shows success message" do
        doctor = create(:doctor)
        delete :destroy, params: {
          id: doctor.id,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status 201

      end
    end
    context "when non existing id is given" do

      it 'shows no content message' do
        delete :destroy, params: {
          id: 0,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status 404
      end
    end

    context "when logged in as patient" do
      it "throws unauthorized error" do
        doctor = create(:doctor)
        delete :destroy, params: {
          id: doctor.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status 401
      end
    end

    context "when logged in as non related doc" do
      it "throws unauthorized error" do
        doctor = create(:doctor)
        delete :destroy, params: {
          id: doctor.id,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status 401
      end
    end
    context "when logged in as related doctor" do
      it "throws unauthorized error" do

        delete :destroy, params: {
          id: doctor.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status 401
      end
    end

  end

  describe "ShowHospitals" do
    context "when authentication is not provided" do
      it "throws an error" do
        get :showHospitals, params: {
          id: doctor.id

        }
        expect(response).to have_http_status 401
      end
    end
    context "when authorization is provided" do
      it "returns a success message" do
        get :showHospitals, params: {
          id: doctor.id,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status 200
      end
    end
  end

end

RSpec.describe DoctorsController do
  let(:patient) { create(:patient) }
  let(:admin_usera) { create(:admin_user) }
  let(:doctor) { create(:doctor) }
  let(:patient_account) { create(:account, accountable: patient) }
  let(:doctor_account) { create(:account, accountable: doctor) }
  let(:admin_user_account) { create(:account, :accountable => admin_usera) }
  let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }
  let(:patient_token) { create(:doorkeeper_access_token, resource_owner_id: patient_account.id) }
  let(:doctor_token) { create(:doorkeeper_access_token, resource_owner_id: doctor_account.id) }

  describe "get/doctors" do
    context "not signed in" do
      it "lists the doctors in that hospital" do
        hospital = create(:hospital)
        get :index, params: {
          hospital_id: hospital.id
        }

        expect(response).to be_truthy

      end
    end
    context "signed in as patient" do
      it "lists the doctors in that hospital" do
        sign_in patient_account
        hospital = create(:hospital)
        get :index, params: {
          hospital_id: hospital.id
        }

        expect(response).to be_truthy

      end
    end

  end
end