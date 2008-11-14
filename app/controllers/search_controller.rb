class SearchController < ApplicationController
  def results
    value = params[:query] || params[:search][:query]
    case get_query_type(value)
    when "date"
      value = Date.parse_europe(value).strftime('%%%y-%m-%d')
      condition = "(cases.examination_date LIKE :value) OR (patients.birth_date LIKE :value)"
      patient_condition = "(patients.birth_date LIKE :value)"
    when "entry_nr"
      condition = "(cases.praxistar_eingangsnr = :value OR cases.praxistar_eingangsnr REGEXP concat('../0*', :value) OR patients.doctor_patient_nr = :value)"
      patient_condition = "(patients.doctor_patient_nr = :value)"
    when "text"
      condition = "(classifications.name REGEXP :value) OR (cases.finding_text LIKE :value) OR (vcards.given_name LIKE :value) OR (vcards.family_name LIKE :value) OR (vcards.full_name LIKE :value)"
      patient_condition = "(vcards.given_name LIKE :value) OR (vcards.family_name LIKE :value) OR (vcards.full_name LIKE :value)"
    end
    @patients = Patient.find(:all, :include => [:vcards ], :conditions => ["(#{patient_condition}) AND patients.doctor_id IN (:doctor_id)", {:value => value, :doctor_id => @current_doctor_ids}], :limit => 100)
    @cases = Case.find(:all, :include => [:classification => [], :patient => [ :vcards ]], :conditions => ["(#{condition}) AND cases.doctor_id IN (:doctor_id)", {:value => value, :doctor_id => @current_doctor_ids}], :limit => 100)

    render :layout => false
  end

  private
  def get_query_type(value)
    if value.match(/([[:digit:]]{1,2}\.){2}/)
      return "date"
    elsif value.match(/^([[:digit:]]{0,2}\/)?[[:digit:]]*$/)
      return "entry_nr"
    else
      return "text"
    end
  end
end
