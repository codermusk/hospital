class HospitalController < ApplicationController
  def index
    @hospitals = Hospital.all
  end

  def show
    @hospitals = Hospital.find(params[:id])
  end

  def new
    @hospitals = Hospital.new
  end

  def  create
    @hospitals = Hospital.new hospital_params

    if  @hospitals.save
      redirect_to @hospital
    else
    render :new,status: :unprocessable_entity
    end
  end

  def edit
    @hospitals = Hospital.find params[:id]
    if @hospitals.update hospital_params
      redirect_to @hospital
    else
      render :new , status: :unprocessable_entity

    end

  end
  private
  def hospital_params
    params.require(:hospital).permit(:name , :address , :mail )
  end
end