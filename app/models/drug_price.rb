class DrugPrice < ActiveRecord::Base
  belongs_to :drug_article

  named_scope :valid, :conditions => ['valid_from <= ?', Date.today]
  named_scope :public, :conditions => ['price_type = ?', 'PPUB']
  named_scope :current, :order => 'valid_from DESC', :limit => 1
end
