# -*- encoding : utf-8 -*-
class DrugSubstance < ActiveRecord::Base
  def to_s
    name
  end

  def self.clever_find(query, *args)
    return [] if query.nil? or query.empty?

    query_params = {}

    query_params[:query] = "%#{query}%"

    self.all(:conditions => ["name LIKE :query OR description LIKE :query", query_params], :order => 'name')
  end
end
