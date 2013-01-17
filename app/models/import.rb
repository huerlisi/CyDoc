# -*- encoding : utf-8 -*-
class Import < ActiveRecord::Base
  serialize :error_ids, Array
  serialize :error_messages, Array
end
