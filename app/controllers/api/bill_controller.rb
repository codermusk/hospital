class Api::BillController < Api::ApiController

  before_action :doorkeeper_authorize!
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
    @bill = Bill.find(params[:id])
    @prescribtion = @bill.prescribtion
    render json: @prescribtion , status: 200
  end

  def show
    if current_account.accountable_id==Bill.find(params[:id]).prescribtion.appointment.patient_id
      @bill = Bill.find(params[:id])
      render json: @bill ,status: 200
    else
      render json: {error:"Unproceeable entity"} , status: 422
    end
  end


  def destroy
    @bill = Bill.find(params[:id])
    if @bill.destroy
      render json: {success:"Deleted Successfully"} , status: 200
    else
      render json: {error:"Unproceeable entity"} , status: 422
    end
  end

  def update
    @bill = Bill.find(params[:id])
    if @bill.update bill_params
      render json: @bill , status: 200
    else
      render json: {error:"Unproceeable entity"} , status: 422
    end

  end


  def bill_params
    params.require(:bill).permit(:doctor_fees , :status)
  end

end