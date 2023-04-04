class Api::DoctorsController < Api::ApiController

  before_action :doorkeeper_authorize!
  before_action :check , only: [:show , :edit , :update , :destroy]

  def check
    @doctor = Doctor.find params[:id]
  rescue
    head :not_found
  end
  def index
    @doctors = Hospital.find(params[:hospital_id]).doctors
    render json: @doctors , status:200

  end

  def  showRating
    @doctor = Doctor.find(params[:id])
    if @doctor
    @ratings = @doctor.ratings
    render json: @ratings , status: 200
    else
      render json:{error:"No doctor Found"} , status: 422
     end
  end

  def showHospitals
    @doctor = Doctor.find(params[:id])
    @hospitals = @doctor.hospitals
    render json:  @hospitals , status: 200

  end





  def show

    @doctor = Doctor.find params[:id]
    if current_account.accountable == @doctor
      render json: @doctor , status:200
    else
      head :forbidden
    end


  end

  def create
    @doctor = Doctor.new doctor_params
    if @doctor.save
      render json: @doctor , status:200
    else
      render json: {error:"UnProcessable Entity"} , status: 425
    end
  end


  def destroy
    @doctor = Doctor.find(params[:id])
    if @doctor.destroy
      render json: {success:"success"} , status: 201
    else
      render json: {error:"Method not allowed"} , status: 405
    end
  end

  def update
    @doctor = Doctor.find(params[:id])
    if current_account.accountable == @doctor
      if @doctor.update doctor_params
        render json: @doctor , status: 201
      else
        render json: {error:"Method not allowed"} , status: 405
      end
    else
      head :forbidden
    end
  end




  private
  def doctor_params
    params.require(:doctor).permit(:name , :email , :address , :dateofjoining , :status , :specialization )
  end
end