class Api::HospitalsController < Api::ApiController

  before_action :doorkeeper_authorize!

  before_action :check , only: [:update , :destroy , :show , :showRatings , :edit]


  def  check
    @hospital = Hospital.find params[:id]
  rescue
    render json: {message:"not found"} , status: 404
  end

    def index

      @hospitals = Hospital.all
      render json: @hospitals , status: 200
    end


  def  showRatings
    @ratings  = @hospital.ratings
    render json: @ratings , status:200

  end

  def edit
    if current_account.accountable.is_a? AdminUser
      render json: @hospital , status: 200
    else
      head :forbidden
    end
  end

    def show
      @hospital = Hospital.find(params[:id])
      render json: @hospital , status: 200
    end
    def  create
      if current_account.accountable.is_a? AdminUser

      @hospital = Hospital.new hospital_params

      if  @hospital.save
        render json: @hospital , status: 201
      else
        render json: {error: "Error Creating the Object"} , status: 420
      end
      else
        head :forbidden
      end
    end
    def  update
      if current_account.accountable.is_a?AdminUser
      @hospital  = Hospital.find(params[:id])
      if @hospital.update hospital_params
        render json: @hospital   , status: 201
      else
        render json:{error:"Not Updated"} , status:405
      end
      else
        head :forbidden
      end
    end
    def  destroy
      if current_account.accountable.is_a?AdminUser
      if @hospital.destroy
        render json: {success:"Succefully deleted"}     , status: 201
      else
        render json:{error:"Not Deleted"} , status:405
      end
      else
        head :forbidden
      end
    end

    private
    def hospital_params
      params.require(:hospital).permit(:name , :address , :mail  )
    end

    end


