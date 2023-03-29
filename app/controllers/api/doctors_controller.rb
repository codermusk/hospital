class Api::DoctorsController < ApplicationController
  def index
    @doctors = Hospital.find(params[:hospital_id]).doctors
    render json: @doctors , status:200

  end

  def show
    @doctor = Doctor.find params[:id]
    render json: @doctor , status:200
  end


end