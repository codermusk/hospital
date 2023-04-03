class Api::PatientsController < Api::ApiController

  before_action :doorkeeper_authorize!

  def index

    @patients = Patient.all
    render json: @patients, status: 200
  end

  def show
    @patient = Patient.find(params[:id])
    if current_account.accountable == @patient
      @patient = Patient.find(params[:id])
      render json: @patient, status: 200

    else
      render json: { error: "User Does'nt have access to this " }, status: 422
    end
  end

  def create

    @patient = Patient.new patient_params
    if @patient.save
      render json: @patient, status: 200
    else
      render json: { error: "Method not allowed" }, status: 405
    end
  end

  def edit
    @patient = Patient.find(params[:id])
    if current_account.accountable == @patient
      render json: @patient, status: 200
    else
      render json: { error: "Method not allowed" }, status: 405
    end

  end

  def update
    @patient = Patient.find(params[:id])
    if current_account.accountable == @patient
      if @patient.update patient_params
        render json: @patient, status: 200
      else
        render json: { error: "Not Modified " }, status: 304
      end
    end

  end

  def destroy

    @patient = Patient.find(params[:id])
    if current_account.accountable == @patient
      if @patient.destroy
        render json: { success: "Deleted Successfully" }, status: 200
      end
    end
  end

  private
  def  patient_params
    params.require(:patient).permit(:name , :address , :age , :email)
  end

end