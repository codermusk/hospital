class Rating < ApplicationRecord
  paginates_per 5
  scope :get_ratings_hos,->{where ratable_type: 'Hospital'}
  scope :get_ratings_doc,->{where ratable_type: 'Doctor'}
  scope :get_all,->{order(rating: :desc)}
  validates :review , presence:true , length: {minimum: 10 , maximum: 50}
  validates :rating , presence:true  ,numericality: {greater_than: 0 ,less_than: 11}
  belongs_to :ratable , polymorphic: true
  belongs_to :patient
end