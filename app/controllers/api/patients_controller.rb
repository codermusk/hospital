class Api::PatientsController < Api::ApiController

  before_action :doorkeeper_authorize!

  before_action :check , only: [:show , :edit  , :destroy , :update ]

  def check
    @patient = Patient.find(params[:id])
  rescue
    render json: {message:"not found"} , status: 404
  end

  def index
    if current_account.accountable.is_a? AdminUser
    @patients = Patient.all
    render json: @patients, status: 200
    else
      head :unauthorized
    end
  end

  def show
    if current_account.accountable == @patient or current_account.accountable.is_a? AdminUser
      @patient = Patient.find(params[:id])
      render json: @patient, status: 200

    else
      head :unauthorized
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
    if current_account.accountable == @patient or current_account.accountable.is_a? AdminUser
      render json: @patient, status: 200
    else
      render json: { error: "Method not allowed" }, status: 401
    end

  end

  def update
    if current_account.accountable == @patient || current_account.accountable.is_a?(AdminUser)
      if @patient.update patient_params
        render json: @patient, status: 200
        end
    else
      head :unauthorized
    end

  end

  def destroy
    if current_account.accountable == @patient or current_account.accountable.is_a? AdminUser
      if @patient.destroy
        render json: { success: "Deleted Successfully" }, status: 200
      end
    else
      head :unauthorized
    end
  end

  private
  def  patient_params
    params.require(:patient).permit(:name , :address , :age , :email)
  end

end