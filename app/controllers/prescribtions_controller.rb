class PrescribtionsController < ApplicationController
  def new
    @prescribtion = Prescribtion.new
  end

  def create

    @apponintment = Appointment.find(params[:appointment_id])
    @prescribtion = @apponintment.create_prescribtion prescribtion_params
    @prescribtion.create_bill bill_params
    if @prescribtion.save
      redirect_to doctor_appointments_path(current_account.accountable_id) , status: "prescribed SuccessFully"
    end
    end

  def edit
    @prescribtion = Prescribtion.find(params[:id])

  end

  def  show
    @prescribtion = Prescribtion.find(params[:id])
  end
  def update
    @prescribtion = Prescribtion.find(params[:id])
    if @prescribtion.update prescribtion_params
      redirect_to doctor_appointments_path(current_account.accountable_id) , notice: "Prescription Updated"

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