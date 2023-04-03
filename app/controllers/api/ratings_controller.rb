class Api::RatingsController < Api::ApiController

  before_action :doorkeeper_authorize!

  def create
    if params[:ratable] == 'hospitals'
      @hospital = Hospital.find(params[:ratable_id])
      @rating = @hospital.ratings.build rating_params
      @rating.patient_id = current_account.id
      if @rating.save
        render json: @rating, status: 200
      else
        render json: { error: "un authorized" }, status: 422
      end
    else
      @doctor = Doctor.find(params[:ratable_id])
      @rating = @doctor.ratings.build rating_params
      @rating.patient_id = current_account.id
      if @rating.save
        render json: @rating, status: 200
      else
        render json: { error: "un authorized" }, status: 422
      end

    end

  end

  def edit

    @rating = Rating.find(params[:id])
    if current_account.accountable == @rating.patient
      render json: @rating, status: 200
    else
      head :unprocessable_entity

    end

  end

  def index
    if params[:ratable] == 'hospitals'
      @ratings = Hospital.find(params[:ratable_id]).ratings
      render json: @ratings, status: 200
    else
      @ratings = Doctor.find(params[:ratable_id]).ratings
      render json: @ratings, status: 200
    end

  end

  def show
    @rating = Rating.find(params[:id])
    render json: @rating, status: 200
  end

  def destroy
    @rating = Rating.find(params[:id])
    if @rating.patient_id == current_account.accountable_id
      if @rating.destroy
        render json: { success: "deleted Successfully" }, status: 200
      else
        render json: { error: "un authorized method" }, status: 422
      end
    else
      head :forbidden
    end
  end

  def update

    @rating = Rating.find(params[:id])

    if current_account.accountable == @rating.patient

      if @rating.update rating_params
        render json: @rating, status: 200
      else
        render json: { error: "un authorized" }, status: 422
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:rating, :review)
  end

end