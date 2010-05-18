module RecallsHelper
  def link_to_last_session(recall)
    session = recall.patient.treatments.map{|t| t.sessions}.flatten.first
    return "Kein Termin" if session.nil?
    
    return link_to session.duration_from.try(:to_date), treatment_path(session.treatment)
  end
end
