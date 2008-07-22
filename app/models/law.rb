class Law < ActiveRecord::Base
  has_many :invoices
end
