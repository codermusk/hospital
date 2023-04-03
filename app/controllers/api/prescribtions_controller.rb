class Api::PrescribtionsController < Api::ApiController

  before_action :doorkeeper_authorize!

  def new
    @apponintment = Appointment.find(params[:appointment_id])
    if current_account.accountable == @apponintment.doctor
      @prescribtion = Prescribtion.new
    end

  end

  def create

    @apponintment = Appointment.find(params[:appointment_id])
    if current_account.accountable == @apponintment.doctor
      @prescribtion = @apponintment.create_prescribtion prescribtion_params
      @prescribtion.create_bill bill_params
      if @prescribtion.save
        render json: @prescribtion, status: 200
      else
        render json: { error: "Cannot create an prescribtion" }, status: 422
      end
    else
      head :unprocessable_entity
    end

  end

  def edit
    @apponintment = Appointment.find(params[:appointment_id])
    if current_account.accountable == @apponintment.doctor

      @prescribtion = Prescribtion.find(params[:id])
      render json: { message: "ok" }, status: 200
    else
      head :unprocessable_entity
    end

  end

  def show
    @prescribtion = Prescribtion.find(params[:id])
    @patient = @prescribtion.appointment.patient
    if current_account.accountable == @patient

      render json: @prescribtion, status: 201
    else
      head :unprocessable_entity
    end
  end

  def update

    @prescribtion = Prescribtion.find(params[:id])
    if current_account.accountable == @prescribtion.appointment.doctor
      if @prescribtion.update prescribtion_params
        render json: @prescribtion, status: 201
      else
        render json: { error: "Un Authorized Entity" }, status: 401

      end
    else
      head :unprocessable_entity
    end
  end

  private

  def prescribtion_params
    params.require(:prescribtion).permit(:tablets, :comments)

  end

  def bill_params
    params.require(:bill_attributes).permit(:doctor_fees)
  end

end