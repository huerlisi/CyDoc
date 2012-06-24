class Law < ActiveRecord::Base
  validates_presence_of :code

  has_many :invoices

  def name
    code.gsub(/^Law/, '').upcase
  end
end
