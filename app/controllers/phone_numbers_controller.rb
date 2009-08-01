class PhoneNumbersController < ApplicationController
  in_place_edit_for :phone_number, :number

  # GET /phone_numbers/new
  def new
    @phone_number = PhoneNumber.new
    @patient = Patient.find(params[:patient_id])

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_phone_number", :partial => 'form'
        end
      }
    end
  end

  # PUT /phone_number
  def create
    @patient = Patient.find(params[:patient_id])
    @phone_number = @patient.phone_numbers.build(params[:phone_number])
    
    if @phone_number.save
      flash[:notice] = 'Kontakt erfasst.'

      respond_to do |format|
        format.html {
          redirect_to @patient
          return
        }
        format.js {
          render :update do |page|
            page.insert_html :top, 'phone_numbers', :partial => 'phone_numbers/item', :object => @phone_number
            page.remove 'phone_number_form'
          end
        }
      end
    else
      render :action => :new
    end
  end

  def destroy
    @phone_number = PhoneNumber.find(params[:id])
    
    @phone_number.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "phone_number_#{@phone_number.id}"
        end
      }
    end
  end
end
