class Api::PatientsController < ApplicationController

  skip_before_action :verify_authenticity_token
  def index
    @patients = Patient.all
    render  json: @patients , status: 200
  end

  def show
    @patient = Patient.find(params[:id])
    render json: @patient , status: 200
  end

  def create

    @patient = Patient.new patient_params
    if @patient.save
      render json:@patient , status: 200
    else
      render json:{error:"Method not allowed"} , status:405
    end
  end

  def edit
    @patient = Patient.find(params[:id])
  end


  def update
    @patient = Patient.find(params[:id])
    if @patient.update patient_params
      render json: @patient , status:201
    else
      render json:{error:"Not Modified "} , status: 304
    end

  end

  def patient_params
    params.require(:patient).permit(:name , :sex , :email , :mobile_number , :age, :address )
  end
end