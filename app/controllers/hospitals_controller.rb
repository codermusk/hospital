class HospitalsController < ApplicationController
  def index
    if current_account&.accountable_type =='Doctor'
        redirect_to doctor_appointments_path(current_account.accountable_id)
    end
    @hospitals = Hospital.all
  end

  def show
    @hospital = Hospital.find(params[:id])
  end

  def new
    @hospital = Hospital.new
  end

  def  create
    @hospital = Hospital.new hospital_params

    if  @hospital.save
      redirect_to @hospital
    else
    render :new,status: :unprocessable_entity
    end
  end

  def edit
    @hospital = Hospital.find params[:id]
  end

  def update
    @hospital = Hospital.find params[:id]
    if @hospital.update hospital_params
      redirect_to @hospital
    else
      render :edit , status: :unprocessable_entity
    end


  end
  private
  def hospital_params
    params.require(:hospital).permit(:name , :address , :mail )
  end
end