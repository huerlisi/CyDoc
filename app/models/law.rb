class Law < ActiveRecord::Base
  has_many :invoices

  def name
    type.to_s.gsub(/^Law/, '').upcase
  end
end
