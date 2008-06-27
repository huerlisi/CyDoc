class ClassificationGroup < ActiveRecord::Base
  has_many :classifications, :class_name => 'Cyto::Classification'
end
