class Case < ActiveRecord::Base
  belongs_to :classification
  belongs_to :patient
  belongs_to :doctor
  belongs_to :insurance
  
  def to_s
    "#{patient.to_s}: PAP Abstrich #{praxistar_eingangsnr}"
  end

  def create_treatment(provider)
    puts self.praxistar_eingangsnr

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
    if treatment.save
      self.session = session
      self.save
      
      return nil
    else
      logger.info("[Error] Failed to create treatment for case #{self.praxistar_eingangsnr}:")
      logger.info(treatment.errors.full_messages.join("\n"))
      
      return self
    end

    treatment
  end

  named_scope :finished, :conditions => ["screened_at IS NOT NULL AND (needs_review = ? OR review_at IS NOT NULL)", false]
  named_scope :no_treatment, :conditions => ["session_id IS NULL"]

  def self.create_all_treatments
    failed_cases = []

    cases = self.finished.no_treatment
    for a_case in cases
      failed_cases << a_case.create_treatment(Doctor.find_by_code('zytolabor'))
    end

    return cases.count, failed_cases.compact
  end
end
