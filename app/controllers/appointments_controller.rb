class AppointmentsController < ApplicationController
  def book
    @appointment = Patient.first.appointments.create appointment_params
    @appointment.doctor_id = params[:doctor_id]
    @doctor = Doctor.find(params[:doctor_id])
    @hospital = @doctor.hospital.id
    if @appointment.save
      redirect_to hospital_doctors_path(@hospital) , notice: "Appointment Booked Successfully"
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

  def destroy
    @appointment = Appointment.find(params[:id])
    @patient = @appointment.patient
    if @appointment.destroy
      redirect_to patient_appointments_path(@patient), notice: "Deleted Successfully"
    end
  end
  def appointment_params
    params.require(:appointment).permit(:appointment_date , :time  )
  end
end
