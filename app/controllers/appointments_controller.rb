class AppointmentsController < ApplicationController
  def book
    if current_account
    @appointment = current_account.accountable.appointments.create appointment_params
    @appointment.doctor_id = params[:doctor_id]
    @doctor = Doctor.find(params[:doctor_id])
    @hospital = @doctor.hospital.id
    if @appointment.save
      redirect_to hospital_doctors_path(@hospital) , notice: "Appointment Booked Successfully"
    end
    else
      redirect_to hospitals_path , notice: "Login to Book Appointment"
    end
  end
  def index
    if current_account.accountable_type == "Doctor"
      @doctor = Doctor.find(params[:doctor_id])
      @appointments = @doctor.appointments

    else
    @patient = Patient.find(params[:patient_id])
    @appointments = @patient.appointments
    end
  end

  def update
    @appointment = Appointment.find(params[:id])
    status = Hash.new
    status['status'] =1
     if @appointment.update(status)
      redirect_to doctor_appointments_path(current_account.accountable_id)
    end
  end



  def destroy
    @appointment = Appointment.find(params[:id])
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