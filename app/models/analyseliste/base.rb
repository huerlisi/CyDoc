require 'fastercsv'

module Analyseliste
  class Base
    include Importer

    def self.path(options = {})
      return options[:input] if options[:input]
      
      options[:version] ||= 'new'
      name = (options[:version] == 'new') ? 'analyseliste.csv' : 'analyseliste_old.csv'

      case ENV['RAILS_ENV']
        when 'production': File.join(RAILS_ROOT, 'data', name)
        when 'development', 'test': File.join(RAILS_ROOT, 'test', 'fixtures', 'analyseliste', name)
      end
    end

    def self.find(selector, options = {})
      FasterCSV.read(path(options), :headers => true)
    end

    def self.import_all(do_clean = false, options = {})
      LabTariffItem.import(do_clean, options)
      LabTariffItem.import(false, options.merge({:version => 'old'}))
    end
  end
end
