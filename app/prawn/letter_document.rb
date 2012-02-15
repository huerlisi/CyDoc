require 'prawn/measurement_extensions'

module Prawn
  class LetterDocument < Prawn::Document

    include ApplicationHelper
    include ActionView::Helpers::TranslationHelper
    include I18nRailsHelpers
    include VcardHelper::InstanceMethods
    include Prawn::Measurements

    def h(s)
      return s
    end

    def initialize_fonts
      font 'Helvetica'
      font_size 9.5
    end

    def default_options
      {:page_size => 'A4'}
    end

    def initialize(opts = {})
      # Default options
      opts.reverse_merge!(default_options)

      # Set the template
      letter_template = Attachment.find_by_code(self.class.name)
      opts.reverse_merge!(:template => letter_template.file.current_path) if letter_template
      
      super
      
      # Default Font
      initialize_fonts
    end
    
    # Letter header with company logo, receiver address and place'n'date
    def letter_header(sender, receiver, subject)
      move_down 60

      # Address
      float do
        canvas do
          bounding_box [12.cm, bounds.top - 6.cm], :width => 10.cm do
            draw_address(receiver.vcard)
          end
        end
      end

      move_down 4.cm

      # Place'n'Date
      text [sender.vcard.try(:locality), I18n.l(Date.today, :format => :long)].compact.join(', ')

      # Subject
      move_down 60
      text subject, :style => :bold
    end
    
    # Freetext
    def free_text(text = "")
      text " "
      text text, :inline_format => true
      text " "
    end
    
    # Draws the full address of a vcard
    def draw_address(vcard)
      vcard.full_address_lines.each do |line|
        text line
      end
    end

    def common_closing(sender)
      text " "
      text " "

      text I18n.t('letters.greetings')
      text "#{sender.vcard.full_name}"
    end
  end
end
