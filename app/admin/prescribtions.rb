ActiveAdmin.register Prescribtion do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :tablets, :appointment_id, :comments
  filter :tablets
  #
  # or
  #
  # permit_params do
  #   permitted = [:tablets, :appointment_id, :comments]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
