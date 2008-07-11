class SearchController < ApplicationController
  def results
    value = params[:search][:query]
    case get_query_type(value)
    when "date"
      conditions = ["(cases.entry_date = :value) OR (patients.birth_date = :value)", {:value => Date.parse(value)}]
    when "entry_nr"
      conditions = ["(cases.praxistar_eingangsnr = ?)", value]
    when "text"
      conditions = ["(cases.finding_text LIKE :value) OR (vcards.given_name LIKE :value) OR (vcards.family_name LIKE :value) OR (vcards.full_name LIKE :value)", {:value => value}]
    end
    @cases = Case.find(:all, :include => [:patient => [ :vcard ] ], :conditions => conditions)
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
