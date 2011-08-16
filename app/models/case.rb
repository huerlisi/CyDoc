class Case < ActiveRecord::Base
  belongs_to :classification
  belongs_to :patient
  belongs_to :doctor
  belongs_to :insurance
  
  def to_s
    "#{patient.to_s}: PAP Abstrich #{praxistar_eingangsnr}"
  end

  def create_treatment(provider)
    # Law
    law = LawKvg.new(:insured_id => patient.insurance_policies.by_policy_type('KVG').first.number)
    
    # Treatment
    treatment = patient.treatments.build(
      :date_begin => examination_date,
      :date_end   => examination_date,
      :canton     => 'ZH',
      :reason     => 'Krankheit',
      :law        => law,
      :referrer   => doctor
    )
    
    # Session
    session = treatment.sessions.build(
      :duration_from => examination_date,
      :duration_to   => examination_date,
      :treatment     => treatment
    )

    if classification
      # TariffItem
      tariff_code = "#{classification.name} (#{classification.examination_method.name})"
      tariff_item = TariffItem.clever_find(tariff_code).first
      
      # Service Records
      session.build_service_record(tariff_item)
    end

    # Save record
    treatment.save
  end
end
