class Treatment < ActiveRecord::Base
  has_and_belongs_to_many :diagnoses
  has_many :invoices
  belongs_to :patient
  belongs_to :referrer, :class_name => 'Doctor'
  belongs_to :law

  has_many :sessions
  
  def to_s(format = :default)
    case format
    when :short
      "#{reason}: #{date_begin.strftime('%d.%m.%Y')}"
    else
      "#{patient.name} #{reason}: #{date_begin.strftime('%d.%m.%Y')} - #{date_end.strftime('%d.%m.%Y')}"
    end
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
