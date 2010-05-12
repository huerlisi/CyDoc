class Treatment < ActiveRecord::Base
  has_many :invoices
  belongs_to :patient
  belongs_to :referrer, :class_name => 'Doctor'
  belongs_to :law, :dependent => :destroy

  has_many :sessions, :order => 'duration_from DESC', :dependent => :destroy
  has_many :medical_cases, :order => 'type', :dependent => :destroy
  
  validates_presence_of :reason, :place_type
  validates_date :date_begin
  validates_date :date_end, :allow_blank => true
  
  named_scope :open, :include => :invoices, :conditions => "invoices.id IS NULL", :order => 'date_begin'

  # TODO: this doesn't work in many cases: only partially charged, invoice canceled...
  named_scope :charged, :include => :invoices, :conditions => "invoices.id IS NOT NULL", :order => 'date_begin'
  
  def validate_for_invoice
    errors.add_to_base("Keine Diagnose eingegeben.") if medical_cases.empty?
  end
  
  def valid_for_invoice?
    valid?
    validate_for_invoice
    
    errors.empty?
  end

  def date_begin_formatted
    date_begin
  end

  def date_begin_formatted=(value)
    write_attribute(:date_begin, Date.parse_europe(value, :past))
  end

  def date_end_formatted
    date_end
  end

  def date_end_formatted=(value)
    write_attribute(:date_end, Date.parse_europe(value, :past))
  end

  def to_s(format = :default)
    case format
    when :short
      [reason, date_begin.nil? ? nil : date_begin.strftime('%d.%m.%Y')].join(': ')
    else
      "#{patient.nil? ? 'Patient unbekannt' : patient.name} #{reason}: #{date_begin.strftime('%d.%m.%Y') if date_begin} - #{date_end.strftime('%d.%m.%Y') if date_end}"
    end
  end
  
  def amount
    sessions.to_a.sum(&:amount).to_f
  end
  
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
