# -*- encoding : utf-8 -*-
class DiagnosisCase < MedicalCase
  belongs_to :diagnosis

  before_save :create_or_set_diagnosis

  def to_s(format = :default)
    return "Unbekannte Diagnose" if diagnosis.nil?

    [diagnosis.code, diagnosis.text].compact.join ' - '
  end

  private
  def create_or_set_diagnosis
    # Use Freetext if no diagnoses given
    if diagnosis.nil?
      diag = Diagnosis.first(:conditions => {:type => 'DiagnosisFreetext', :text => remarks})
      if diag.nil?
        diag = DiagnosisFreetext.new(:text => remarks)
        diag.save
      end
      write_attribute(:diagnosis_id, diag.id)
    end
  end
end
