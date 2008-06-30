class FindingClass < ActiveRecord::Base
  has_and_belongs_to_many :cases
  has_and_belongs_to_many :finding_groups

  def belongs_to_group?(name)
    finding_groups.collect { |group| group.name }.include?(name)
  end
end
