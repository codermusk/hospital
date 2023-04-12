class AppointmentsController < ApplicationController
  before_action :check , except: [:book , :index]

  def check
    @appointment = Appointment.find(params[:id].to_i)
  rescue
    flash.now[:error] = "No Appointment found"

  end
  def book
    if current_account
    @appointment = current_account.accountable.appointments.create appointment_params
    @appointment.doctor_id = params[:doctor_id].to_i
    @doctor = Doctor.find(params[:doctor_id])
    if @appointment.save
      redirect_to patient_appointments_path(current_account.accountable_id) , notice: "Appointment Booked Successfully"
    end
    else
      redirect_to hospitals_path , notice: "Login to Book Appointment"
    end
  end

  def decline
    @appointment = Appointment.find(params[:id].to_i)
    status = Hash.new
    status['status'] =2
    if @appointment.update(status)
      flash.now[:notice] = "Booking Declined"
    end
  end
  def index
    if  current_account && current_account.accountable_type == "Doctor"
      @doctor = Doctor.find(current_account.accountable_id)
      @appointments = @doctor.appointments.includes(:prescribtion).includes(:patient).page params[:page]

    elsif current_account
    @patient = Patient.find(current_account.accountable_id)
    @appointments = @patient.appointments.includes(:doctor).includes(:prescribtion).page params[:page]
    end
  end

  def update

    status = Hash.new
    status['status'] =1
     if @appointment.update(status)
       flash.now[:notice] = "Booking Confirmed"
    end
  end



  def destroy
    @patient = @appointment.patient
    if @appointment.destroy
      if current_account.accountable_type=="Patient"
      redirect_to patient_appointments_path(@patient), notice: "Deleted Successfully"
      elsif
      redirect_to doctor_appointments_path(current_account.accountable_id) , notice: 'Deleted Successfully'
      end

    end
  end
  def appointment_params
    params.require(:appointment).permit(:appointment_date , :time  )
  end
end
