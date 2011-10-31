class Case < ActiveRecord::Base
  belongs_to :classification
  belongs_to :patient
  belongs_to :doctor
  belongs_to :insurance
  belongs_to :session

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
      
      raise "Tarif für code '#{classification.name} (#{classification.examination_method.name})' nicht gefunden" unless tariff_item

      # Service Records
      session.build_service_record(tariff_item)
    end

    # Save record
    if treatment.save
      self.session = session
      self.save
    else
      logger.info("[Error] Failed to create treatment for case #{self.praxistar_eingangsnr}:")
      logger.info(treatment.errors.full_messages.join("\n"))
    end

    treatment
  end

  BILL_DELAY_DAYS = 6.5
  named_scope :to_create_treatment, :conditions => ["session_id IS NULL AND (IFNULL(email_sent_at, result_report_printed_at) < now() - INTERVAL ? HOUR ) AND classification_id IS NOT NULL", BILL_DELAY_DAYS * 24]

  def self.create_all_treatments
    for a_case in self.to_create_treatment
      a_case.create_treatment(Doctor.find_by_code('zytolabor'))
    end

    nil
  end
end
