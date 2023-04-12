class BillController < ApplicationController
  def update
    @bill = Bill.find(params[:id].to_i)
    @prescribtion = Prescribtion.find(@bill.prescribtion.id)
    up = Hash.new
    up['status'] = true
    if @bill.update up
      redirect_to  appointments_path(current_account.accountable_id), status: "Bill paid"
    end
  end
end