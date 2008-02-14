class Mailing < ActiveRecord::Base
  belongs_to :doctor
  has_and_belongs_to_many :cases
end
