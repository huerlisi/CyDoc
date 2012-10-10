class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :confirmable, :validatable

  # CyDoc
  belongs_to :object, :polymorphic => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :sender_email
end
