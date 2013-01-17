# -*- encoding : utf-8 -*-
class HelpController < ApplicationController
  # No authentication
  skip_before_filter :login_required, :authenticate
  
  def help
      render 'app/views/index.html'
  end
end
