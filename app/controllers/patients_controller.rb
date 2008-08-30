class PatientsController < ApplicationController
  in_place_edit_for :vcard, :family_name
  in_place_edit_for :vcard, :given_name
  in_place_edit_for :vcard, :street_address
  in_place_edit_for :vcard, :postal_code
  in_place_edit_for :vcard, :locality
  in_place_edit_for :patient, :birth_date
  in_place_edit_for :patient, :in_place_doctor_patient_nr
  in_place_edit_for :patient, :in_place_insurance_nr
                
  # CRUD Actions
  def index
  end
  
  def new
    patient = params[:patient]
    @patient = Patient.new(patient)
    @vcard = Vcards::Vcard.new(params[:vcard])
    @vcard.honorific_prefix = 'Frau'
    @vcard.address = Vcards::Address.new

    @patients = []
    render :action => 'list'
  end

  def show
    @patient = Patient.find(params[:id])

    @record_tarmed = RecordTarmed.new
    @record_tarmed.provider_id = @current_doctor.id

    # Defaults
    @record_tarmed.date = Date.today
    @record_tarmed.quantity = 1
    @record_tarmed.responsible_id = @current_doctor.id

    @record_tarmed.patient_id = @patient.id
  end

  # Search
  # ======
  def vcard_conditions(vcard_name = 'vcard')
    vcard_params = params[:vcard] || {}
    keys = []
    values = []

    fields = vcard_params.reject { |key, value| value.nil? or value.empty? }
    fields.each { |key, value|
      keys.push "#{vcard_name}.#{key} LIKE ?"
      values.push '%' + value.downcase.gsub(' ', '%') + '%'
    }

    return !keys.empty? ? [ keys.join(" AND "), *values ] : nil
  end

  def patient_conditions
    parameters = params[:patient]
    keys = []
    values = []

    unless parameters[:full_name].nil? or parameters[:full_name].empty?
      keys.push "patient_id = ?"
      values.push parameters[:full_name].split(' ')[0].strip
    end

    unless parameters[:doctor_patient_nr].nil? or parameters[:doctor_patient_nr].empty?
      keys.push "doctor_patient_nr = ?"
      values.push parameters[:doctor_patient_nr].strip
    end

    unless parameters[:birth_date].nil? or parameters[:birth_date].empty?
      keys.push "birth_date LIKE ? "
      values.push Date.parse_europe(parameters[:birth_date]).strftime('%%%y-%m-%d')
    end

    return !keys.empty? ? [ keys.join(" AND "), *values ] : nil
  end


  def search
    keys = []
    values = []
    
    default_vcard_keys, *default_vcard_values = vcard_conditions('vcards')
    billing_vcard_keys, *billing_vcard_values = vcard_conditions('billing_vcards_patients')
    
    unless default_vcard_keys.nil?
      keys.push "( ( #{default_vcard_keys} ) OR ( #{billing_vcard_keys} ) )"
      values.push *default_vcard_values
      values.push *billing_vcard_values
    end
    
    patient_keys, *patient_values = patient_conditions
    keys.push patient_keys
    values.push *patient_values
    
    # Build conditions array
    if keys.compact.empty?
      @patients = []
    else
      conditions = !keys.compact.empty? ? [  keys.compact.join(" AND "), *values ] : nil
      @patients = Patient.find :all, :conditions => conditions, :include => [:vcard, :billing_vcard], :order => 'vcards.family_name'
    end
  
    render :partial => 'search_result'
  end
  
  # Services
  def list_services
    @patient = Patient.find(params[:id])
    render :partial => 'tariff_items/list', :locals => {:items => @patient.record_tarmeds}
  end

  def new_service
    @patient = params[:id]
    @record_tarmed = RecordTarmed.new
    @record_tarmed.provider_id = @current_doctor.id

    # Defaults
    @record_tarmed.date = Date.today
    @record_tarmed.quantity = 1
    @record_tarmed.responsible_id = @current_doctor.id

    @record_tarmed.patient_id = params[:patient_id]
  end

  def delete_service
    RecordTarmed.destroy(params[:id])
    redirect_to :action => 'list_services'
  end
end
