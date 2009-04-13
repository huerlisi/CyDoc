class DrugProduct < ActiveRecord::Base
  def to_s
    "#{name} - #{description}"
  end
end
