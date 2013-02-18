# -*- encoding : utf-8 -*-
class Tenant < ActiveRecord::Base
  # Associations
  belongs_to :doctor, :foreign_key => :person_id
  has_many :users
  attr_accessible :user_ids

  # Person
  # ======
  belongs_to :person
  accepts_nested_attributes_for :person
  attr_accessible :person_attributes

  # Settings
  has_settings
  attr_accessible :settings

  def to_s
    doctor.to_s
  end

  # Fiscal Years
  # ============
  validates_date :fiscal_year_ends_on

  def fiscal_year_ends_on
    settings[:fiscal_year_ends_on] || Booking.first.try(:value_date).try(:end_of_year) || Date.today.end_of_year
  end

  def fiscal_period(year)
    final_day_of_fiscal_year = Date.new(year, fiscal_year_ends_on.month, fiscal_year_ends_on.day)
    first_day_of_fiscal_year = final_day_of_fiscal_year.ago(1.year).in(1.day)

    return :from => first_day_of_fiscal_year.to_date, :to => final_day_of_fiscal_year.to_date
  end

  def fiscal_years
    first_year = fiscal_year_ends_on.year
    final_year = Date.today.year + 1

    (first_year..final_year).map{|year|
      fiscal_period(year)
    }
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
