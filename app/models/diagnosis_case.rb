class DiagnosisCase < MedicalCase
  belongs_to :diagnosis
  
  before_save :create_or_set_diagnosis
  
  def self.to_s
    "Diagnose"
  end

  private
  def create_or_set_diagnosis
    # TODO: generalize
    diag = Diagnosis.find(:first, :conditions => {:type => 'DiagnosisFreetext', :text => remarks})
    if diag.nil?
      diag = DiagnosisFreetext.new(:text => remarks)
      diag.save
    end
    write_attribute(:diagnosis_id, diag.id)
  end
end
