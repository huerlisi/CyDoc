# -*- encoding : utf-8 -*-
class AppointmentsController < AuthorizedController
  # Filter
  has_scope :by_period, :using => [:from, :to]

  # GET /appointments
  def index
    @appointments = apply_scopes(Appointment).active.order(:date).page params['page']
    @recalls = apply_scopes(Recall).active.order(:due_date).page params['page']
  end

  # GET /patients/1/appointments/new
  def new
    @patient = Patient.find(params[:patient_id])
    @appointment  = @patient.appointments.build

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_appointment", :partial => 'form'
        end
      }
    end
  end

  # PUT /patients/1/appointment
  def create
    @patient = Patient.find(params[:patient_id])
    @appointment  = @patient.appointments.build(params[:appointment])

    if @appointment.save
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html 'appointments', :partial => 'appointments/patient_item', :collection => @patient.appointments.active
            page.replace_html 'new_appointment'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace 'appointment_form', :partial => 'appointments/form', :object => @appointment
          end
        }
      end
    end
  end

  # GET /appointment/1/edit
  def edit
    @patient = Patient.find(params[:patient_id])
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'new_appointment', :partial => 'appointments/form'
        end
      }
    end
  end

  # PUT /appointment/1
  # PUT /patients/1/appointment/2
  def update
    @patient = Patient.find(params[:patient_id])
    @appointment = Appointment.find(params[:id])

    if @appointment.update_attributes(params[:appointment])
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html 'appointments', :partial => 'appointments/patient_item', :collection => @patient.appointments.active
            page.replace_html 'new_appointment'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html 'appointment_form', :partial => 'appointments/form'
          end
        }
      end
    end
  end

  # POST /appointment/1/obey
  def obey
    @appointment = Appointment.find(params[:id])
    @appointment.obey
    @appointment.save

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "appointment_#{@appointment.id}"
        end
      }
    end
  end

  # DELETE /appointment/1
  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "appointment_#{@appointment.id}"
        end
      }
    end
  end

  # GET /patients/1/appointments/1
  def show
    @appointment  = Appointment.find(params[:id])
    @patient = @appointment.patient

    respond_to do |format|
      format.pdf {
        render :layout => false
      }
    end
  end
end
