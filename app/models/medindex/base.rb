module Medindex
  class Base < Importer
    def self.load
      path = File.join(RAILS_ROOT, 'data', 'Medindex', "DownloadMedindex#{self.name.demodulize}_out.xml")
      @@data = REXML::Document.new(File.new(path))
    end

    def self.import_all(do_clean = false)
      Medindex::Insurance.import(do_clean)
      Medindex::Substance.import(do_clean)
    end

    def self.all
      data.root.elements
    end
  end
end

class REXML::Element
  def field(selector)
    elements[selector + '/text()'].to_s
  end
end
