# -*- encoding : utf-8 -*-

module DiagnosisCodes
  class Base
    include Importer

    def self.path(options = {})
      return options[:input] if options[:input]

      name = "#{self.name.demodulize}.csv"

      case Rails.env
        when 'production'
          File.join(Rails.root, 'data', 'diagnosis_codes', name)
        when 'development', 'test'
          File.join(Rails.root, 'test', 'fixtures', 'diagnosis_codes', name)
      end
    end

    def self.all(options = {})
      CSV.read(path(options), :col_sep => ';', :headers => false)
    end

    def self.import_all(do_clean = false, options = {})
      ByContractCode.import(do_clean, options)
    end
  end
end
