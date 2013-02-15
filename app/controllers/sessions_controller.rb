# -*- encoding : utf-8 -*-
class SessionsController < AuthorizedController
  belongs_to :treatment
  # GET /sessions/new
  def new
    @treatment.sessions.create(:duration_from => DateTime.now)

    new!
  end
end
