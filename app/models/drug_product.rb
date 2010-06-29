class DrugProduct < ActiveRecord::Base
  # Associations
  has_many :drug_articles, :dependent => :destroy

  # Validations
  validates_presence_of :name, :description
  
  def to_s
    "#{name} - #{description}"
  end

  def self.clever_find(query, *args)
    return [] if query.nil? or query.empty?

    query_params = {}
    
    query_params[:query] = "%#{query}%"
    
    find(:all, :conditions => ["name LIKE :query OR description LIKE :query", query_params], :order => 'name')
  end
end
