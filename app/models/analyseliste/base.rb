require 'fastercsv'

module Analyseliste
  class Base
    @@data = nil
    
    def self.load
      path = File.join(RAILS_ROOT, 'data', 'analyseliste.csv')
      @@data = FasterCSV.read(path)
    end

    def self.data
      @@data || self.load
    end

    def self.all
      data
    end

    def self.import
      Medindex::TariffItem.import
    end
  end
end
