class Api::BillController < Api::ApiController

  before_action :doorkeeper_authorize!
  before_action :check , only: [:update , :edit , :destroy , :show , :showPresc]


  def check
    @bill = Bill.find(params[:id])
  rescue
    render json: {message:"not found"} , status: 404
  end

  def index
    if current_account.accountable.is_a?AdminUser
      @bills = Bill.all
      render json: @bills , status: 200
    else
      head :unauthorized
    end
  end
  def create
    @prescribtion = Prescribtion.find(params[:id])
    @bill  = @prescribtion.build_bill bill_params
    if @bill.save
      render json: @bill , status: 201
    else
      render json: {error:"un processable entity"} , status: 422
    end

  end


  def showPresc
    @prescribtion = @bill.prescribtion
    render json: @prescribtion , status: 200
  end

  def show
    if current_account.accountable_id==@bill.prescribtion.appointment.patient_id || current_account.accountable.is_a?(AdminUser) || current_account.accountable==@bill.prescribtion.appointment.doctor
      @bill = Bill.find(params[:id])
      render json: @bill ,status: 200
    else
      head :unauthorized
    end
  end


  def destroy
    if current_account.accountable.is_a?(AdminUser)
    if @bill.destroy
      render json: {success:"Deleted Successfully"} , status: 200
    else
      render json: {error:"Unproceeable entity"} , status: 422
    end
    else
      head :unauthorized
      end
  end

  def update
    @bill = Bill.find(params[:id])
    if current_account.accountable.is_a?(AdminUser) || current_account.accountable==@bill.prescribtion.appointment.doctor
    if @bill.update bill_params
      render json: @bill , status: 200
    else
      render json: {error:"Unprocessable entity"} , status: 422
    end
    else
      head :unauthorized
    end

  end


  def bill_params
    params.require(:bill).permit(:doctor_fees , :status)
  end

end