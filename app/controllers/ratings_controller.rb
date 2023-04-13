class RatingsController < ApplicationController
  before_action :check , only: [:index]
  def check
    if params[:ratable] == 'hospitals'
      begin
      @hospital = Hospital.find params[:ratable_id].to_i
      rescue
      redirect_to hospitals_path , alert: "not allowed"
      end
    else
      begin
        @doctor = Doctor.find params[:ratable_id].to_i
        rescue
        redirect_to hospitals_path , alert: "not allowed"
        end
    end
  end
  def index
    if params[:ratable] == 'hospitals'
      @hospital = Hospital.find params[:ratable_id]
      @ratings = @hospital.ratings.order(:rating).includes(:patient).page params[:page]
    else
      @doctor = Doctor.find params[:ratable_id]
      @ratings = @doctor.ratings.order(:rating).includes(:patient).page params[:page]
    end
  end

  def create
    if current_account
      if params[:ratable] == 'hospitals'
        @hospital = Hospital.find params[:ratable_id]
        @rating = @hospital.ratings.build rating_params
        @rating.patient_id = current_account.accountable_id
        if @rating.save
          redirect_to hospital_ratings_path(params[:ratable_id]), notice: "rating successfully created"
        end
      elsif params[:ratable] == 'doctors'
        @doctor = Doctor.find params[:ratable_id]
        @rating = @doctor.ratings.build rating_params
        @rating.patient_id = current_account.accountable_id
        if @rating.save
          redirect_to "/doctors/#{params[:ratable_id]}/ratings", notice: "rating successfully created"
        else
          render :new , notice: "Try again"
        end
        end
      else
        redirect_to hospitals_path , alert: "Login to Give a Rating"
      end



  end

  def destroy
    @ratings = Rating.find(params[:id])
    if @ratings.destroy

    end
  end

  private

  def rating_params
    params.require(:rating).permit(:rating, :review)
  end
end