# -*- encoding : utf-8 -*-
class DrugProduct < ActiveRecord::Base
  # Access restrictions
  attr_accessible :name, :description

  # Associations
  has_many :drug_articles, :dependent => :destroy

  # Validations
  validates_presence_of :name, :description

  def to_s
    "#{name} - #{description}"
  end

  def self.clever_find(query, *args)
    return self.scoped if query.nil? or query.empty?

    query_params = {}

    query_params[:query] = "%#{query}%"

    self.where("name LIKE :query OR description LIKE :query", query_params).order('name')
  end
end
