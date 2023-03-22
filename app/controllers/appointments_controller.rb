class AppointmentsController < ApplicationController
  def book
    @appointment = Patient.first.appointments.create appointment_params
    @appointment.doctor_id = params[:doctor_id]
    @doctor = Doctor.find(params[:doctor_id])
    @hospital = @doctor.hospital.id
    if @appointment.save
      redirect_to hospital_doctors_path(@hospital)
    end
  end
  def index
    @patient = Patient.first!
    @appointments = @patient.appointments
  end
  def appointment_params
    params.require(:appointment).permit(:appointment_date , :time  )
  end
end
