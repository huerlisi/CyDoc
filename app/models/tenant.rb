class Tenant < ActiveRecord::Base
  # Associations
  belongs_to :doctor, :foreign_key => :person_id
  has_many :users

  # Settings
  has_settings

  def to_s
    doctor.to_s
  end

  # Attachments
  # ===========
  has_many :attachments, :as => :object
  accepts_nested_attributes_for :attachments, :reject_if => proc { |attributes| attributes['file'].blank? }

  # Printing
  # ========
  def printer_for(type)
    type = type.to_s
    if settings['printing.cups_hostname'].present?
      CupsPrinter.new(settings['printing.' + type], :hostname => settings['printing.cups_hostname'])
    else
      CupsPrinter.new(settings['printing.' + type])
    end
  end
end
