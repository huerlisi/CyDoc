class Treatment < ActiveRecord::Base
  # Associations
  has_many :invoices, :dependent => :destroy, :order => 'value_date DESC, created_at DESC'
  belongs_to :patient
  belongs_to :referrer, :class_name => 'Doctor'
  belongs_to :law, :dependent => :destroy

  has_many :sessions, :order => 'duration_from DESC', :dependent => :destroy
  has_many :medical_cases, :order => 'type', :dependent => :destroy
  
  # Validation
  validates_presence_of :reason, :place_type
  validates_date :date_begin
  validates_date :date_end, :allow_blank => true
  
  def validate_for_invoice(invoice)
    if invoice.settings['validation.medical_case_present']
      errors.add_to_base("Keine Diagnose eingegeben.") if medical_cases.empty?
    end
  end
  
  def valid_for_invoice?(invoice)
    valid?
    validate_for_invoice(invoice)
    
    errors.empty?
  end

  # State
  named_scope :open, :conditions => "treatments.state = 'open'", :order => 'date_begin'
  named_scope :charged, :conditions => "treatments.state = 'charged'", :order => 'date_begin'
  
  def open?
    state == 'open'
  end
  
  def chargeable?
    sessions.open.present?
    # Checking for valid_for_invoice? would be a nice thing, too. But links depending on this would need AJAX updates.
  end
  
  # Callback hook for invoice
  def update_state
    if sessions.empty?
      # Set state to 'new' if no sessions are associated
      new_state = 'new'
    else
      if chargeable?
        # Set state to 'open' if any session is open
        new_state = 'open'
      else
        # Set state to 'charged' as no session is ready to bill
        new_state = 'charged'
      end
    end

    update_attribute(:state, new_state)

    new_state
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

  # Hozr Integration
  has_many :cases, :through => :sessions

  named_scope :ready_to_bill, proc {|grace_period|
    date = DateTime.now().ago(grace_period.days)
    {
      :joins => {:sessions => :case},
      :conditions => ["screened_at < :date AND (needs_review = :false OR review_at < :date)", {:date => date, :false => false}]
    }
  }
end
