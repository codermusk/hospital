require 'rails_helper'
RSpec.describe Api::RatingsController do
  let(:patient) { create(:patient) }
  let(:admin_usera) { create(:admin_user) }
  let(:doctor) { create(:doctor) }
  let(:patient_account) { create(:account, accountable: patient) }
  let(:doctor_account) { create(:account, accountable: doctor) }
  let(:admin_user_account) { create(:account, :accountable => admin_usera) }
  let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }
  let(:patient_token) { create(:doorkeeper_access_token, resource_owner_id: patient_account.id) }
  let(:doctor_token) { create(:doorkeeper_access_token, resource_owner_id: doctor_account.id) }
  describe "Get/Ratings" do
    context "index" do
      it "requires authentication" do
        hospital = create(:hospital)
        # rating = create(:rating , ratable: hospital)
        get :index, params: {

          ratable_id: hospital.id,
          ratable: 'hospitals',
          # access_token: admin_user_token.token
        }
        expect(response).to have_http_status(401)

      end

      it "can be accessed by admin" do
        hospital = create(:hospital)

        get :index, params: {

          ratable_id: hospital.id,
          ratable: 'hospitals',
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "can be accessed by all patients" do
        hospital = create(:hospital)

        get :index, params: {

          ratable_id: hospital.id,
          ratable: 'hospitals',
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "can be accessed by all doctors" do
        hospital = create(:hospital)

        get :index, params: {

          ratable_id: hospital.id,
          ratable: 'hospitals',
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(200)
      end
    end
    context "show" do
      it "requires authentication" do
        hospital = create(:hospital)
        rating = create(:rating, ratable: hospital)
        get :show, params: {

          id: rating.id
          # access_token: admin_user_token.token
        }
        expect(response).to have_http_status(401)

      end

      it "can be accessed by admin" do
        hospital = create(:hospital)
        rating = create(:rating, ratable: hospital)
        get :index, params: {
          id: rating.id,
          ratable_id: hospital.id,
          ratable: 'hospitals',
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end

      it "can be accessed by all patients" do
        hospital = create(:hospital)
        rating = create(:rating, ratable: hospital)

        get :index, params: {
          id: rating.id,
          ratable_id: hospital.id,
          ratable: 'hospitals',
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "can be accessed by all doctors" do
        hospital = create(:hospital)
        rating = create(:rating, ratable: hospital)
        get :index, params: {
          id: rating.id,
          ratable_id: hospital.id,
          ratable: 'hospitals',
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "put/:id/ratings" do
    context "update" do
      it "requires authentication" do
        rating = create(:rating)
        put :update, params: {
          id: rating.id,
          rating: {
            rating: 10
          }
        }
        expect(response).to have_http_status(401)
      end

      it "can be done by admin" do
        rating = create(:rating)
        put :update, params: {
          id: rating.id,
          rating: {
            rating: 10
          },
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "can be done by that patient" do
        rating = create(:rating, patient: patient)
        put :update, params: {
          id: rating.id,
          rating: {
            rating: 10
          },
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "can't be done by that patient" do
        patient = create(:patient)
        rating = create(:rating, patient: patient)
        put :update, params: {
          id: rating.id,
          rating: {
            rating: 10
          },
          access_token: patient_token.token
        }
        expect(response).to have_http_status(401)
      end

      it "cant be done by doc" do
        rating = create(:rating, patient: patient)
        put :update, params: {
          id: rating.id,
          rating: {
            rating: 10
          },
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(401)
      end
      it "should be valid" do
        put :update, params: {
          id: 0,
          rating: {
            rating: 10
          },
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "Delete :id/rating" do
    context "delete" do

      it "requires authentication" do
        rating = create(:rating)
        delete :destroy, params: {
          id: rating.id
        }
        expect(response).to have_http_status(401)
      end
      it "can be done by admin" do
        rating = create(:rating)
        delete :destroy, params: {
          id: rating.id,
          access_token: admin_user_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "can be done by that patient" do
        rating = create(:rating, patient: patient)
        delete :destroy, params: {
          id: rating.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(200)
      end
      it "cant be done by other patients" do
        rating = create(:rating)
        delete :destroy, params: {
          id: rating.id,
          access_token: patient_token.token
        }
        expect(response).to have_http_status(401)
      end
      it "cant be done by doctors" do
        rating = create(:rating)
        delete :destroy, params: {
          id: rating.id,
          access_token: doctor_token.token
        }
        expect(response).to have_http_status(401)
      end
    end
  end
end