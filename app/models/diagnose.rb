class Diagnose < ActiveRecord::Base
  has_and_belongs_to_many :treatments

  def type
    class_subname = read_attribute(:type).to_s.gsub(/^Diagnose/, '')
    if class_subname.upcase == class_subname
      return class_subname
    else
      return class_subname.underscore
    end
  end
end
