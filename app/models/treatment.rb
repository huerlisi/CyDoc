class Treatment < ActiveRecord::Base
  # Associations
  has_many :invoices, :dependent => :destroy
  belongs_to :patient
  belongs_to :referrer, :class_name => 'Doctor'
  belongs_to :law, :dependent => :destroy

  has_many :sessions, :order => 'duration_from DESC', :dependent => :destroy
  has_many :medical_cases, :order => 'type', :dependent => :destroy
  
  # Validation
  validates_presence_of :reason, :place_type
  validates_date :date_begin
  validates_date :date_end, :allow_blank => true
  
  def validate_for_invoice
    errors.add_to_base("Keine Diagnose eingegeben.") if medical_cases.empty?
  end
  
  def valid_for_invoice?
    valid?
    validate_for_invoice
    
    errors.empty?
  end

  # State
  # TODO: this doesn't work in many cases: only partially charged, invoice canceled...
  named_scope :open, :include => :invoices, :conditions => "invoices.id IS NULL", :order => 'date_begin'
  named_scope :charged, :include => :invoices, :conditions => "invoices.id IS NOT NULL", :order => 'date_begin'
  
  def open?
    invoices.active.empty?
  end
  
  def chargeable?
    sessions.open.present?
    # Checking for valid_for_invoice? would be a nice thing, too. But links depending on this would need AJAX updates.
  end
  
  # Helpers
  def to_s(format = :default)
    case format
    when :short
      [reason, date_begin.nil? ? nil : I18n.l(date_begin)].join(': ')
    else
      "#{patient.nil? ? 'Patient unbekannt' : patient.name} #{reason}: #{I18n.l(date_begin) if date_begin} - #{I18n.l(date_end) if date_end}"
    end
  end
  
  def amount
    sessions.to_a.sum(&:amount)
  end
  
  # XML Invoices
  def reason_xml
    case reason
      when 'Unfall': 'accident'
      when 'Krankheit': 'disease'
      when 'Mutterschaft': 'maternity'
      when 'Prävention': 'prevention'
      when 'Geburtsfehler': 'birthdefect'
    end
  end
end
