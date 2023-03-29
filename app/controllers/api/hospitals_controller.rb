class Api::HospitalsController < ApplicationController

    def index
      if current_account&.accountable_type =='Doctor'
        redirect_to doctor_appointments_path(current_account.accountable_id)
      end
      @hospitals = Hospital.all
      render json: @hospitals , status: 200
    end

    def show
      @hospital = Hospital.find(params[:id])
      end
    def  create
      @hospital = Hospital.new hospital_params

      if  @hospital.save
        render json: @hospital , status: 201
      else
        render json: {error: "Error Creating the Object"} , status: 420
      end
    end

    private
    def hospital_params
      params.require(:hospital).permit(:name , :address , :mail )
    end
  end

