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


  def create
    @hospital  = Hospital.first!
    @doctor = @hospital.doctors.create doctor_params
    if @doctor.save
    redirect_to hospital_path(@hospital)
    end


  end

  def edit
    @doctor = Doctor.find params[:id]
  end


  private
  def doctor_params
    params.require(:doctor).permit(:name , :age , :dateofjoining , :email , :address , :specialization)

  end


end