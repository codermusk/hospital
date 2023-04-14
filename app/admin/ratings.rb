ActiveAdmin.register Rating do
  permit_params :review, :rating, :ratable_type, :ratable_id, :patient_id
  index do
    selectable_column
    id_column
    column  :ratable
    column "Reviewed by" ,  :patient
    column :rating
    column :review
  end
  filter  :rating ,label: "Rating Provided"
  filter :patient_id  , as: :select , collection: ->{Patient.all.collect  {|pat| [pat.name , pat.id]}}
  scope "Hospital" ,:get_ratings_hos
  scope "Doctor" ,:get_ratings_doc
end
