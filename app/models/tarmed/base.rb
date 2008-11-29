class Tarmed::Base < ActiveRecord::Base
  use_db :prefix => "tarmed_"

  def lang
    'D'
  end
end
