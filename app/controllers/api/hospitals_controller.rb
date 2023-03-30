class Api::HospitalsController < ApplicationController
  skip_before_action :verify_authenticity_token

    def index
      if current_account&.accountable_type =='Doctor'
        redirect_to doctor_appointments_path(current_account.accountable_id)
      end
      @hospitals = Hospital.all
      render json: @hospitals , status: 200
    end


  def  showRatings
    @hospital  = Hospital.find(params[:id])
    @ratings  = @hospital.ratings
    render json: @ratings , status:200
  end

    def show
      @hospital = Hospital.find(params[:id])
      render json: @hospital , status: 200
      end
    def  create
      @hospital = Hospital.new hospital_params

      if  @hospital.save
        render json: @hospital , status: 201
      else
        render json: {error: "Error Creating the Object"} , status: 420
      end
    end
    def  update
      @hospital  = Hospital.find(params[:id])
      if @hospital.update hospital_params
        render json: @hospital   , status: 201
      else
        render json:{error:"Not Updated"} , status:405
      end
    end
    def  destroy
      @hospital = Hospital.find(params[:id])
      if @hospital.destroy
        render json: {success:"Succefully deleted"}     , status: 201
      else
        render json:{error:"Not Deleted"} , status:405
      end
    end

    private
    def hospital_params
      params.require(:hospital).permit(:name , :address , :mail )
    end

    end


