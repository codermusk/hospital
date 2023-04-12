class DoctorsController < ApplicationController

  def index
    @doctors = Hospital.find(params[:hospital_id].to_i).doctors.includes(:ratings)
  end

  def search
    @hospital = Hospital.find(params[:hospital_id].to_i)
    query = params["query"]
    if query.present?
      @doctors = Doctor.joins(:hospitals).where("hospitals.id = ? AND doctors.specialization ILIKE ?",params[:hospital_id].to_i,"%#{query}%").includes(:ratings)
    else
      @doctors = @hospital.doctors.includes(:ratings)
    end
    respond_to do |format|
      format.turbo_stream
      format.html { render :index }
    end
  end

  def show
    @doctor = Doctor.find params[:id].to_i
  end

  def build
    @doctor = Hospital.doctors.build
  end

  def edit
    @doctor = Doctor.find params[:id].to_i
  end

  private

  def doctor_params
    params.require(:doctor).permit(:name, :age, :dateofjoining, :email, :address, :specialization)

  end

end