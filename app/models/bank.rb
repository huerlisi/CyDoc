class Bank < ActiveRecord::Base
  has_one :vcard, :as => :object
end
