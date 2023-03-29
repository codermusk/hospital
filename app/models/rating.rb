class Rating < ApplicationRecord
  scope :get_ratings_hos,->{where ratable_type: 'Hospital'}
  scope :get_ratings_doc,->{where ratable_type: 'Doctor'}
  scope :get_all,->{order(rating: :desc)}
  validates :review , presence:true
  validates :rating , presence:true  ,numericality: {greater_than: 0 ,less_than: 11}
  belongs_to :ratable , polymorphic: true
  belongs_to :patient
end