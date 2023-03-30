ActiveAdmin.register Rating do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #


  permit_params :review, :rating, :ratable_type, :ratable_id, :patient_id
  index do
    selectable_column
    id_column
    column  :ratable
    column :rating
    column :review


  end

  filter  :rating ,label: "Rating Provided"
  filter :patient_id
  # filter :ratable
  scope "Hospital" ,:get_ratings_hos
  scope "Doctor" ,:get_ratings_doc

  # scope default
  #
  # or
  #
  # permit_params do
  #   permitted = [:review, :rating, :ratable_type, :ratable_id, :patient_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
