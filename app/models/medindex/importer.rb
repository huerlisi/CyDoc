module Medindex
  class Importer
    include ::Importer

    def self.import_all(do_clean = false)
      import_classes = [Medindex::Insurance, Medindex::Substance, Medindex::Product, Medindex::Article]
      
      for import_class in import_classes
        # Clear all entries if demanded
        clean(import_class.int_class) if do_clean

        REXML::Document.parse_stream(File.new(path(import_class)), import_class.new)
      end
    end

    protected
    def self.path(import_class)
      case ENV['RAILS_ENV']
        when 'production': File.join(RAILS_ROOT, 'data', 'Medindex', "DownloadMedindex#{import_class.name.demodulize}_out.xml")
        when 'development', 'test': File.join(RAILS_ROOT, 'test', 'fixtures', 'medindex', "DownloadMedindex#{import_class.name.demodulize}_out.xml")
      end
    end
  end
end
