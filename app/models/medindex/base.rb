module Medindex
  class Base < Listener
    include Importer

    def self.path
      case ENV['RAILS_ENV']
        when 'production': File.join(RAILS_ROOT, 'data', 'Medindex', "DownloadMedindex#{self.name.demodulize}_out.xml")
        when 'development', 'test': File.join(RAILS_ROOT, 'test', 'fixtures', 'medindex', "DownloadMedindex#{self.name.demodulize}_out.xml")
      end
    end

    def self.import_all(do_clean = false)
      import_classes = [Medindex::Insurance, Medindex::Substance, Medindex::Product, Medindex::Article]
      
      # Clear all entries if demanded
      for import_class in import_classes
        import_class.clean if do_clean
        REXML::Document.parse_stream(File.new(import_class.path), import_class.new)
      end
    end
  end
end
