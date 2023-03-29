ActiveAdmin.register Hospital do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :address, :mail, :doctor_ids

  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :address, :mail]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  form do |f|
    f.semantic_errors
    f.inputs
    f.input :doctor_ids do
      f.has_many :doctors, new_record: true, allow_destroy: true do |t|
        t.input :id
      end
    end
    f.actions
  end

end

