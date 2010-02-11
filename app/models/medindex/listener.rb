require 'rexml/streamlistener'

module Medindex
  class Listener
    include REXML::StreamListener
    
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
          @int_record.save!
          puts @int_record
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
