class Tarmed::Base < ActiveRecord::Base
  require 'yaml'
  
  use_db :prefix => "tarmed_"

  def lang
    'D'
  end
end
