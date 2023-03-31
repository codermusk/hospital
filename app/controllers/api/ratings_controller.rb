class Api::RatingsController < Api::ApiController

  before_action :doorkeeper_authorize!
  def create
    @hospital = Hospital.find(params[:id])
    @rating = @hospital.ratings.build rating_params
    if @rating.save
      render json: @rating , status: 200
    else
      render json: {error:"un authorized"} , status:422
    end
  end

  def edit
    @rating = Rating.find(params[:id])
    render json: @rating , status:200

  end

  def  index
    @ratings = Rating.all
    render json: @ratings , status:200
  end

  def  show
    @rating = Rating.find(params[:id])
    render json: @rating , status: 200
  end

  def  destroy
    @rating = Rating.find(params[:id])
    if @rating.destroy
      render json: {success:"deleted Successfully"} , status:200
    else
      render json:{error:"un authorized method"} , status:422
    end
  end

  def update
    @rating = Rating.find(params[:id])
    if @rating.update rating_params
      render json: @rating , status: 200
    else
      render json: {error:"un authorized"} , status: 422
    end
    end
  private
  def rating_params
    params.require(:rating).permit(:rating, :review)
  end

end