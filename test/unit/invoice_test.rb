require File.dirname(__FILE__) + '/../test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def test_simple
    patient = patients(:joe)
    record_tarmed = RecordTarmed.new(:code => '00.0010')
    record_tarmed.provider_id = doctors(:test)
        
    record_tarmed.date = Date.today
    record_tarmed.quantity = 1
    record_tarmed.responsible_id = doctors(:test)

    record_tarmed.save
    
    patient.record_tarmeds << record_tarmed
    patient.save
    
    assert_equal 1, patient.record_tarmeds.size
  end
end
