# -*- encoding : utf-8 -*-
module ActsAsDocument
  def pdf_name(name = '')
    name = name.strip
    name = ' ' + name if name.present?
    I18n.transliterate(to_s + name) + '.pdf'
  end

  def document_to_pdf(document_type = nil, params = {})
    self.class.document_type_to_class(document_type).new.to_pdf(self, params)
  end

  def printing_error
    @printing_error || ""
  end

  def print_document(document_type, printer, params = {})
    @printing_error = nil

    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.puts(document_to_pdf(document_type, params))
    file.close

    # Try more than once
    # TODO: try cupsffi gem
    tries = 5
    i = 1
    begin
      paper_copy = Cups::PrintJob.new(file.path, printer)
      paper_copy.print
    rescue RuntimeError => e
      logger.warn("Failed to print to #{printer}. Try ##{i}.")
      logger.warn(e.message)

      if i == tries
        logger.warn("Givin up.")
        @printing_error = e.message
        return false
      end

      i += 1
      # Sleep for 4s
      sleep 4

      retry
    end

    return true
  end

  module ClassMethods
    def document_to_pdf(document_type = nil)
      document_type_to_class(document_type).new.to_pdf(self)
    end

    def document_type_to_class(document_type)
      document_type.to_s.camelcase.constantize
    end
  end

  def self.included(base)
    base.send :extend, ClassMethods
  end
end
