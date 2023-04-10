class DoctorsController < ApplicationController

  def index
    @doctors = Hospital.find(params[:hospital_id]).doctors
  end


  def show
    @doctor = Doctor.find params[:id]
  end

  def build
    @doctor = Hospital.doctors.build
  end
  def edit
    @doctor = Doctor.find params[:id]
  end


  private
  def doctor_params
    params.require(:doctor).permit(:name , :age , :dateofjoining , :email , :address , :specialization)

  end


end