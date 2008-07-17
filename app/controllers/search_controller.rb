class SearchController < ApplicationController
  def results
    value = params[:search][:query]
    case get_query_type(value)
    when "date"
      value = Date.parse(value)
      condition = "(cases.examination_date = :value) OR (patients.birth_date = :value)"
    when "entry_nr"
      condition = "(cases.praxistar_eingangsnr = :value OR cases.praxistar_eingangsnr REGEXP concat('../0*', :value) OR patients.doctor_patient_nr = :value)"
    when "text"
      condition = "(classifications.name REGEXP :value) OR (cases.finding_text LIKE :value) OR (vcards.given_name LIKE :value) OR (vcards.family_name LIKE :value) OR (vcards.full_name LIKE :value)"
    end
    @cases = Case.find(:all, :include => [:classification => [], :patient => [ :vcard ]], :conditions => ["(#{condition}) AND cases.doctor_id IN (:doctor_id)", {:value => value, :doctor_id => @current_doctor_ids}])

    render :layout => false
  end

  private
  def get_query_type(value)
    if value.match(/([[:digit:]]{1,2}\.){2}[[:digit:]]{2,4}/)
      return "date"
    elsif value.match(/^([[:digit:]]{0,2}\/)?[[:digit:]]*$/)
      return "entry_nr"
    else
      return "text"
    end
  end
end
