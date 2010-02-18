class DrugPrice < ActiveRecord::Base
  belongs_to :drug_article

  named_scope :valid, :conditions => ['valid_from <= ?', Date.today]
  named_scope :current, :conditions => ['valid_from <= ?', Date.today], :order => 'valid_from DESC', :limit => 1

  named_scope :public, :conditions => ['price_type = ?', 'PPUB']
  named_scope :doctor, :conditions => {:price_type => ['PDOC', 'PEXF', 'PPHA']}

  def to_s
    "#{price_type} (since #{valid_from}): CHF #{sprintf('%0.2f', price)}"
  end
end
