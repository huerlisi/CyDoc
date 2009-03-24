module Medindex
  class Base
    @@xml = nil
    
    def self.load
      path = File.join(RAILS_ROOT, 'test', 'fixtures', 'medindex', "DownloadMedindex#{self.name.demodulize}_out.xml")
      @@xml = REXML::Document.new(File.new(path))
    end

    def self.xml
      @@xml || self.load
    end

    def self.all
      xml.root.elements
    end
  end
end
