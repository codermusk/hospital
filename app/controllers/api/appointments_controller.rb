class Api::AppointmentsController < Api::ApiController
  before_action :doorkeeper_authorize!


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

    if  current_account&.accountable_type == "Doctor" && current_account.id==params[:id]
      @doctor = Doctor.find(current_account.accountable_id)
      @appointments = @doctor.appointments
      render json: @appointments , status: 200

    elsif current_account&.accountable_id==params[:id]
      @patient = Patient.find(current_account.accountable_id)
      @appointments = @patient.appointments
      # p @appointments
      render json:@appointments , status:200
    else
      render json: {error:"not allowed method"} , status: :forbidden
    end
  end

  def update
    @appointment = Appointment.find(params[:id])
  end
    if current_account&.accountable_type=="Doctor" && current_account.accountable_id==@appointment.doctor_id

    status = Hash.new
    status['status'] =1
    if @appointment.update(status)
      render @appointment , status: 200
    else
      render json: {error:@appointment.error} ,status: :forbidden
    end
  end



  def destroy
    @appointment = Appointment.find(params[:id])
    if current_account&.accountable_id==@appointment.patient_id || current_account&.accountable_id==@appointment.doctor_id
      if @appointment.destroy
        head :success
      end

    end
  end
  def appointment_params
    params.require(:appointment).permit(:appointment_date , :time  )
  end
end