# -*- encoding : utf-8 -*-
class ServiceRecordsController < AuthorizedController
  # GET /service_records/new
  def new
    @service_record = ServiceRecord.new
    @patient = Patient.find(params[:patient_id])
    @session = Session.find(params[:session_id])

    # Defaults
    @service_record.quantity = 1

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.select('.new_session_service_record').each do |form|
            form.hide
          end
          page.show "new_session_#{@session.id}_service_record"
          page.replace_html "new_session_#{@session.id}_service_record", :partial => 'form'
        end
      }
    end
  end

  # POST /service_records
  def create
    tariff_item = TariffItem.find(params[:tariff_item_id])
    @patient = Patient.find(params[:patient_id])
    @session = Session.find(params[:session_id])

    service_record = @session.build_service_record(tariff_item)

    @session.save
  end

  # GET /service_records/select
  def select
    query = params[:search][:query]

    @patient = Patient.find(params[:patient_id])
    @session = Session.find(params[:session_id])

    @tariff_items = TariffItem.clever_find(query).page params['page']
    params[:tariff_item_id] = TariffItem.find_by_code(query)
    create && return
  end

  def destroy
    @session = Session.find(params[:session_id])
    destroy!
  end
end
