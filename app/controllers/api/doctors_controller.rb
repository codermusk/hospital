class Api::DoctorsController < ApplicationController
  def index
    @doctors = Hospital.find(params[:hospital_id]).doctors
    render json: @doctors , status:200

  end

  def show
    @doctor = Doctor.find params[:id]
    render json: @doctor , status:200
  end


  def create
    @hospital = Hospital.new hosp_params
    if @hospital.save
      render json: @hospital , status:200
    else
      render json:{error:"Not Created"} , status:405
    end


  end

  private
  def hosp_params
    params.require(:hospital).permit(:name , :mail , :address)
  end
end