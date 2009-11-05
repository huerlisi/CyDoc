class Law < ActiveRecord::Base
  has_many :invoices

  def name
    self.class.to_s.gsub(/^Law/, '').upcase
  end
end
