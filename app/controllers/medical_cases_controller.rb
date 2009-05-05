class MedicalCasesController < ApplicationController
  def new
    # TODO: generalize like this: @medical_case = Object.const_get(params[:type]).new
    @medical_case = DiagnosisCase.new

    @medical_case.date = Date.today
    
    respond_to do |format|
      format.html { }
      format.js {
        render :partial => 'form'
      }
    end
  end

  def assign
    patient = Patient.find(params[:patient_id])
    diagnosis = Diagnosis.find(params[:id])
    date = params[:date].blank? ? DateTime.now : Date.parse_europe(params[:date])

    # TODO: generalize like this: @medical_case = Object.const_get(params[:medical_case][:type]).new(params[:medical_case])
    @medical_case = DiagnosisCase.new(params[:medical_case])

    @medical_case.doctor = @current_doctor
    @medical_case.patient = patient
    @medical_case.diagnosis = diagnosis
    @medical_case.date = date

    if @medical_case.save
      flash[:notice] = 'Erfolgreich erfasst.'
      respond_to do |format|
        format.html {
          redirect_to patient, :tab => 'medical_history'
          return
        }
        format.js {
          render :update do |page|
            page.replace_html 'medical_case_list', :partial => 'medical_cases/list', :locals => { :items => patient.medical_cases}
            page.replace_html 'search_results', ''
          end
        }
      end
    else
      render :action => 'new'
    end
  end

  # DELETE 
  def destroy
    medical_case = MedicalCase.find(params[:id])
    patient = medical_case.patient
    medical_case.destroy
    
    respond_to do |format|
      format.html {
        redirect_to patient, :tab => 'medical_history'
        return
      }
      format.js {
        render :update do |page|
          page.replace_html 'medical_case_list', partial => 'medical_cases/list', :locals => { :items => patient.medical_cases}
        end
      }
    end
  end
end
