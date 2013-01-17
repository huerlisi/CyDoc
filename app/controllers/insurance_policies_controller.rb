# -*- encoding : utf-8 -*-
class InsurancePoliciesController < ApplicationController
  # GET /insurance_policies/select
  def select
    @patient = Patient.find(params[:patient_id])
    @insurance_policy = @patient.insurance_policies.build
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_insurance_policy", :partial => 'form'
        end
      }
    end
  end
  
  # GET /insurance_policies/new
  def new
    @patient = Patient.find(params[:patient_id])
    @insurance_policy = @patient.insurance_policies.build
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_insurance_policy", :partial => 'form'
        end
      }
    end
  end

  # PUT /insurance_policy
  def create
    @patient = Patient.find(params[:patient_id])
    @insurance_policy = @patient.insurance_policies.build(params[:insurance_policy])
    
    if @insurance_policy.save
      flash[:notice] = 'Versicherung zugewiesen.'

      respond_to do |format|
        format.html {
          redirect_to @patient
          return
        }
        format.js {
          render :update do |page|
            page.insert_html :top, 'insurance_policies', :partial => 'insurance_policies/item', :object => @insurance_policy
            page.remove 'insurance_policy_form'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace 'insurance_policy_form', :partial => 'insurance_policies/form', :object => @insurance_policy
          end
        }
      end
    end
  end

  # DELETE /insurance_policy/1
  def destroy
    @insurance_policy = InsurancePolicy.find(params[:id])
    @insurance_policy.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "insurance_policy_#{@insurance_policy.id}"
        end
      }
    end
  end
end
