class Case < ActiveRecord::Base
  belongs_to :classification
  belongs_to :patient
  belongs_to :doctor
  belongs_to :insurance
  
  def to_s
    "#{patient.to_s}: PAP Abstrich #{praxistar_eingangsnr}"
  end

  def create_invoice(doctor, value_date)
    # Law
    law = LawKvg.new(:insured_id => patient.insurance_policies.by_policy_type('KVG').first.number)
    
    # Treatment
    treatment = patient.treatments.build(
      :date_begin => examination_date,
      :date_end   => examination_date,
      :canton     => 'ZH',
      :reason     => 'Krankheit',
      :law        => law
    )
    
    # Session
    session = treatment.sessions.build(
      :duration_from => examination_date,
      :duration_to   => examination_date,
      :treatment     => treatment
    )
    
    # TariffItem
    tariff_item = TariffItem.clever_find(classification.classification_group.title).first
    
    # Service Records
    session.build_service_record(tariff_item)
    
    # Tiers
    tiers = TiersGarant.new(
      :patient  => patient,
      :biller   => doctor,
      :provider => doctor
    )
    
    # Invoice
    invoice = Invoice.create(
      :value_date      => value_date,
      :due_date        => value_date.in(30.days),
      :tiers           => tiers,
      :law             => law,
      :treatment       => treatment,
      :sessions        => [session],
      :service_records => session.service_records
    )

    session.invoices << invoice
    session.charge
    # Touch session as it won't autosave otherwise
    session.touch
    
    # Book
    invoice.book
    invoice.save
  end
end
