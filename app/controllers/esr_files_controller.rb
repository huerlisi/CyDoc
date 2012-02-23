class EsrFilesController < ApplicationController
  # Inherited Resources
  inherit_resources
protected
  def collection
    instance_eval("@#{controller_name.pluralize} ||= end_of_association_chain.paginate(:page => params[:page], :per_page => params[:per_page])")
  end

public
  before_filter :only => [:index, :show] do
    EsrRecord.update_invalid_states
  end
end
