ActiveAdmin.register Doctor do
  permit_params :name ,  :age ,:email , :address , :dateofjoining , :status , :specialization , account_attributes: [:email , :password , :password_confirmation]
  filter :email
  filter :age
  filter :hospitals
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
  
end
