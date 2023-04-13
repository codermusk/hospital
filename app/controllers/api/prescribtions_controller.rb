class Api::PrescribtionsController < Api::ApiController

  before_action :doorkeeper_authorize!
  before_action :check ,only: [:edit , :update  , :destroy , :show]


  def check
    @prescribtion = Prescribtion.find(params[:id])
  rescue
    render json:{error:"id not found"} , status: 404
  end

  def new
    @apponintment = Appointment.find(params[:appointment_id])
    if current_account.accountable == @apponintment.doctor
      @prescribtion = Prescribtion.new
      head :sucess
    end

  end
  def index
    if current_account.accountable.is_a? AdminUser
      @prescribtions = Prescribtion.all
      render @prescribtions
    else
      head :unauthorized
    end
  end
  def create
    @apponintment = Appointment.find(params[:appointment_id])
    if current_account.accountable == @apponintment.doctor
      @prescribtion = @apponintment.create_prescribtion prescribtion_params
      @prescribtion.create_bill bill_params
      if @prescribtion.save
        render json: @prescribtion, status: 200
      else
        render json: { error: "Cannot create an prescribtion" }, status: 422
      end
    else
      head :unprocessable_entity
    end

  end

  def edit
    @apponintment = Appointment.find(params[:appointment_id])
    if current_account.accountable == @apponintment.doctor || current_account.accountable.is_a?(AdminUser)

      @prescribtion = Prescribtion.find(params[:id])
      render json: { message: "ok" }, status: 200
    else
      head :unauthorized
    end

  end

  def show
    @patient = @prescribtion.appointment.patient
    if current_account.accountable == @patient || current_account.accountable.is_a?(AdminUser) || current_account.accountable==@prescribtion.appointment.doctor

      render json: @prescribtion, status: 200
    else
      head :unauthorized
    end
  end

  def update
    if current_account.accountable == @prescribtion.appointment.doctor || current_account.accountable.is_a?(AdminUser)
      if @prescribtion.update prescribtion_params
        render json: @prescribtion, status: 201
      else
        render status:422

      end
    else
      head :unauthorized
    end
  end

  def  destroy
    if current_account.accountable.is_a?AdminUser
      if @prescribtion.destroy
        head 200
      end
    else
      head :unauthorized
    end
  end

  private

  def prescribtion_params
    params.require(:prescribtion).permit(:tablets, :comments)

  end

  def bill_params
    params.require(:bill_attributes).permit(:doctor_fees)
  end

end