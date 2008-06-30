class Case < ActiveRecord::Base
  belongs_to :classification
  has_and_belongs_to_many :finding_classes
  belongs_to :patient

  def control_findings
    finding_classes.select { |finding| finding.belongs_to_group?('Kontrolle') }
  end

  def quality_findings
    finding_classes.select { |finding| finding.belongs_to_group?('Zustand') }
  end

  def findings
    finding_classes.select { |finding| !(finding.belongs_to_group?('Zustand') || finding.belongs_to_group?('Kontrolle'))}
  end
end
