class DrugArticle < ActiveRecord::Base
  belongs_to :drug_product
  belongs_to :vat_class
  
  def to_s
    "#{code} - #{name}"
  end

  def self.clever_find(query, *args)
    return [] if query.nil? or query.empty?

    query_params = {}
    
    query_params[:query] = "%#{query}%"
    
    find(:all, :conditions => ["name LIKE :query OR description LIKE :query", query_params], :order => 'name')
  end
end
