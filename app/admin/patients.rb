ActiveAdmin.register Patient do

  permit_params :name , :sex , :address , :mobil_number , :age ,account_attributes: [:email , :password , :password_confirmation]
  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.has_many :account, heading: "Account Details", allow_destroy: true do |a|
        a.input :email
        a.input :password
        a.input :password_confirmation
      end
    end
    f.actions
  end

  filter :name
  filter :mobil_number
  filter :sex
  
end
