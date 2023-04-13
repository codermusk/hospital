class Api::AppointmentsController < Api::ApiController
  before_action :doorkeeper_authorize!
  before_action :check , only: [:show , :edit , :destroy , :update]
  # before_action :checkpat , only: [:index , :book]
  def check
    @appointment = Appointment.find params[:id]
  rescue
    render json: {message:"not found"} , status: 404
  end

  def book
    if current_account&.accountable_id==params[:id]
      @appointment = current_account.accountable.appointments.create appointment_params
      @appointment.doctor_id = params[:doctor_id]
      @doctor = Doctor.find(params[:doctor_id])

      if @appointment.save
        render json: @appointment , status: 200
      end
    else
      render json:{error:"forbidden"} , status: :forbidden
    end
  end
  def index
    if current_account.accountable.is_a? AdminUser
      @appointments = Appointment.all
      render json: @appointments , status: 200
    else

    if  current_account&.accountable_type == "Doctor"
      @doctor = Doctor.find(current_account.accountable_id)
      @appointments = @doctor.appointments
      render json: @appointments , status: 200

    elsif current_account&.accountable_id==params[:patient_id].to_i
      @patient = Patient.find(current_account.accountable_id)
      @appointments = @patient.appointments
      # p @appointments
      render json:@appointments , status:200
    else
      render json: {error:"not allowed method"} , status: :unauthorized
    end
    end
  end

  def update
    if current_account.accountable.is_a?AdminUser or current_account.accountable_id==@appointment.doctor_id or current_account.accountable_id==@appointment.patient_id

    if @appointment.update appointment_params
      render json: @appointment , status: 200
    else
      render json: {error:@appointment.error} ,status: :unprocessable_entity
    end
    else
      head :unauthorized
    end

    end

  def show
    if current_account.accountable.is_a?AdminUser or current_account.accountable_id==@appointment.doctor_id or current_account.accountable_id==@appointment.patient_id
    render json:@appointment , status: 200
    else
      head :unauthorized
      end
  end


  def edit
    if current_account.accountable.is_a?AdminUser or current_account.accountable_id==@appointment.doctor_id or current_account.accountable_id==@appointment.patient_id
      render json:@appointment , status: 200
    else
      head :unauthorized
    end
  end
  def destroy
    if current_account&.accountable_id==@appointment.patient_id || current_account&.accountable_id==@appointment.doctor_id or current_account.accountable.is_a?(AdminUser)
      if @appointment.destroy
        render json: {success:"deleted successfully"} , status: 200
      else
        head :unprocessable_entity
      end
    else
      head :unauthorized

    end
  end
  def appointment_params
    params.require(:appointment).permit(:appointment_date , :time  )
  end
end