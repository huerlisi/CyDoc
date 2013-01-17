# -*- encoding : utf-8 -*-
class Diagnosis< ActiveRecord::Base
  has_and_belongs_to_many :treatments

  def to_s
    [code, text].compact.join(' - ')
  end

  def type
    class_subname = read_attribute(:type).to_s.gsub(/^Diagnosis/, '')
    if class_subname.upcase == class_subname
      return class_subname
    else
      return class_subname.underscore
    end
  end
end
