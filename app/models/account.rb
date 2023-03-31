class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  class << self
    def authenticate!(email , password)
      account = find_by(email: email)
      account if account&.valid_password? password

    end
  end
  before_commit do
    email.downcase!
  end
  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :accountable , :polymorphic => true


end
