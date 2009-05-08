require 'rexml/streamlistener'

module Medindex
  class Listener
    include REXML::StreamListener
    
    def tag_start(name, attrs)
      case name
        when record_name:
          @int_record = int_class.new
      end
      @text = ""
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
