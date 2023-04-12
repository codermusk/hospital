class PrescribtionsController < ApplicationController
  before_action :check, only: [:show]

  def check
    @prescribtion = Prescribtion.find params[:id].to_i

  rescue
    flash[:alert] = "Not allowed"
    redirect_to hospitals_path

  end

  def new
    if current_account&.accountable.is_a? Doctor
      @prescribtion = Prescribtion.new
    else
      redirect_to hospitals_path
    end
  end

  def create

    if current_account&.accountable.is_a? Doctor
      @apponintment = Appointment.find(params[:appointment_id].to_i)
      @prescribtion = @apponintment.create_prescribtion prescribtion_params
      @prescribtion.create_bill bill_params

      if @prescribtion.save
        redirect_to doctor_appointments_path(current_account.accountable_id), notice: "prescribed SuccessFully"
      end
    else
      render :new, flash.now[:alert] = "un authorized"
    end
  end

  def edit
    if current_account&.accountable.is_a? Doctor
      @prescribtion = Prescribtion.find(params[:id].to_i)
    else
      redirect_to hospitals_path, notice: "Login as a doctor"
    end

  end

  def show
    if current_account&.accountable.is_a?(Patient) && @prescribtion.appointment.patient_id == current_account.accountable_id
      @prescribtion = Prescribtion.find(params[:id].to_i)
    else
      redirect_to hospitals_path, alert: "Not Allowed"
    end

  end

  def update
    if current_account&.accountable.is_a? Doctor
      @prescribtion = Prescribtion.find(params[:id].to_i)
      if @prescribtion.update prescribtion_params
        redirect_to doctor_appointments_path(current_account.accountable_id), notice: "Prescription Updated"
      end
    else
      redirect_to hospitals_path, notice: "Not Allowed"
    end
  end

  private

  def prescribtion_params
    params.require(:prescribtion).permit(:tablets, :comments, :fees)

  end

  def bill_params
    params.require(:bill_attributes).permit(:doctor_fees)
  end

end