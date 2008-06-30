class FindingGroup < ActiveRecord::Base
  has_and_belongs_to_many :finding_classes
end
