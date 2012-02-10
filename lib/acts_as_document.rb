module ActsAsDocument
  def document_to_pdf(document_type = nil, params = {})
    self.class.document_type_to_class(document_type).new.to_pdf(self, params)
  end

  def print_document(document_type, printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.puts(document_to_pdf(document_type))
    file.close

    # Try twice
    begin
      paper_copy = Cups::PrintJob.new(file.path, printer)
    rescue
      paper_copy = Cups::PrintJob.new(file.path, printer)
    end
    paper_copy.print
  end

  module ClassMethods
    def document_to_pdf(document_type = nil)
      document_type_to_class(document_type).new.to_pdf(self)
    end
  end

  def self.included(base)
    base.send :extend, ClassMethods
  end
end
