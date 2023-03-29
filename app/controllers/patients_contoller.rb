class PatientsController < ApplicationController
  def index
    @patients = Patient.all
  end

  def edit
    @patient = Patient.find(current_account.accountable_id )
  end


  def update
    @patient = Patient.find(current_account.accountable_id )
    if @patient.update patient_params
      redirect_to hospitals_path , notice: "successfully edited the user details"
    else
      render :edit , status: :unprocessable_entity
    end

  end

  def patient_params
    params.require(:patient).permit(:name , :sex , :email , :mobile_number , :age )
  end
end