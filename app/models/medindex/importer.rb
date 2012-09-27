module Medindex
  class Importer
    include ::Importer

    def self.import_all(do_clean = false)
      import_classes = [Medindex::Insurance, Medindex::Substance, Medindex::Product, Medindex::Article]

      for import_class in import_classes
        # Clear all entries if demanded
        clean(import_class.int_class) if do_clean

        import_class.import(File.new(path(import_class)))
      end
    end

    protected
    def self.path(import_class)
      case env['Rails.env']
        when 'production': File.join(Rails.root, 'data', 'Medindex', "DownloadMedindex#{import_class.name.demodulize}_out.xml")
        when 'development', 'test': File.join(Rails.root, 'test', 'fixtures', 'medindex', "DownloadMedindex#{import_class.name.demodulize}_out.xml")
      end
    end
  end
end
