class Api::HospitalsController < Api::ApiController

  before_action :doorkeeper_authorize!

  before_action :check , only: [:update , :destroy , :show , :showRatings , :edit]


  def  check
    @hospital = Hospital.find params[:id]
  rescue
    head :not_found
  end

    def index
      # if current_account&.accountable_type =='Doctor'
      #   redirect_to doctor_appointments_path(current_account.accountable_id)
      # end
      @hospitals = Hospital.all
      render json: @hospitals , status: 200
    end


  def  showRatings
    if @hospital
    @ratings  = @hospital.ratings
    render json: @ratings , status:200
    else
      render json:{error:"Not Found"} , status:422
      end
  end

  def edit
    if current_account.accountable.is_a? AdminUser
      render json: @hospital , status: 200
    else
      head :unauthorized
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
        head :unauthorized
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
        head :unauthorized
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
        head :unauthorized
      end
    end

    private
    def hospital_params
      params.require(:hospital).permit(:name , :address , :mail  )
    end

    end


