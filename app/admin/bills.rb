ActiveAdmin.register Bill do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :doctor_fees, :status, :prescribtion_id
  filter :doctor_fees
  filter :status

  # or
  #
  # permit_params do
  #   permitted = [:doctor_fees, :status, :prescribtion_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
