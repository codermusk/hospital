class Api::BillController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    @prescribtion = Prescribtion.find(params[:id])
    @bill  = @prescribtion.build_bill bill_params
    if @bill.save
      render json: @bill , status: 201
    else
      render json: {error:"un processable entity"} , status: 422
    end

  end

  def show
    @bill = Bill.find(params[:id])
    render json: @bill ,status: 200
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