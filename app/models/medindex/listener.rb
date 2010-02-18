require 'rexml/streamlistener'

module Medindex
  class Listener
    include REXML::StreamListener
    
    attr_accessor :int_record
    
    def self.import(source)
      REXML::Document.parse_stream(source, self.new)
    end

    # Helpers
    def self.find(ext_id)
      if int_id == 'id'
        int_class.find(ext_id)
      else
        int_class.find(:first, :conditions => {int_id => ext_id})
      end
    end
    
    def find
      self.class.find(@int_record.attributes[self.class.int_id])
    end
    
    def create_or_update
      int_record = find
      
      if int_record
        puts "Updating #{int_record}:"
        int_record.attributes = int_record.attributes.merge(@int_record.attributes.reject{|key, value| key == 'updated_at' or key == 'created_at' or key == 'id'})
        changes = int_record.changes.map{|column, values| "  #{column}: #{values[0]} => #{values[1]}"}.join("\n")
        puts changes
      else
        puts "Adding #{int_record}:"
        int_record = @int_record
        changes = int_record.changes.map{|column, values| "  #{column}: #{values[1]}"}.join("\n")
        puts changes
      end
      
      return int_record
    end
    
    # Stream handlers
    def tag_start(name, attrs)
      case name
        when record_name:
          @int_record = self.class.int_class.new
      end
      @text = ""
    end

    def tag_end(name)
      case name
        when record_name:
          @int_record = create_or_update
          @int_record.save!
      end
    end

    def text(content)
      if @text
        @text += content
      else
        @text = content
      end
    end
  end
end
