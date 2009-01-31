class Case < ActiveRecord::Base
  belongs_to :classification
  has_and_belongs_to_many :finding_classes
  belongs_to :patient
  belongs_to :insurance
  belongs_to :doctor
  has_one :order_form
  belongs_to :screened_by, :class_name => 'Employee', :foreign_key => :screener_id
  belongs_to :review_by, :class_name => 'Employee', :foreign_key => :review_by
  belongs_to :examination_method

  # Authorization
  # =============
  def self.find(*args)
    with_scope(:find => {:conditions => {:doctor_id => Thread.current["doctor_ids"]}}) do
      super
    end
  end

  def self.create(attributes = nil, &block)
    with_scope(:create => {:doctor_id => Thread.current["doctor_id"]}) do
      super
    end
  end

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
