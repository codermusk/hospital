class Api::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def current_account
    @current_account ||= Account.find doorkeeper_token[:resource_owner_id]
  end

end