class Api::PrescribtionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
    @prescribtion = Prescribtion.new
  end

  def create

    @apponintment = Appointment.find(params[:appointment_id])
    @prescribtion = @apponintment.create_prescribtion prescribtion_params
    @prescribtion.create_bill bill_params
    if @prescribtion.save
      render json: @prescribtion , status:200
    else
      render json:{error:"Cannot create an prescribtion"} , status:422
    end

  end

  def edit
    @prescribtion = Prescribtion.find(params[:id])
    render json: {message:"ok"} , status:200

  end

  def  show
    @prescribtion = Prescribtion.find(params[:id])
    render json: @prescribtion , status: 201
  end
  def update
    @prescribtion = Prescribtion.find(params[:id])
    if @prescribtion.update prescribtion_params
      render json: @prescribtion , status: 201
    else
      render json: {error:"Un Authorized Entity"} , status: 401

    end
  end
  private
  def prescribtion_params
    params.require(:prescribtion).permit(:tablets , :comments)

  end

  def bill_params
    params.require(:bill_attributes).permit(:doctor_fees)
  end

end