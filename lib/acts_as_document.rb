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
    file = Tempfile.new('')
    file.binmode
    file.puts(document_to_pdf(document_type, params))
    file.close

    printer.print_file(file.path)
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
