# frozen_string_literal: true

class Patient < ApplicationRecord
  has_many :appointments
  has_one :account , :as =>  :accountable
  # belongs_to :doctor
end
