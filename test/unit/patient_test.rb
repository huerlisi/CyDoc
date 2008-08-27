require File.dirname(__FILE__) + '/../test_helper'

class PatientTest < ActiveSupport::TestCase
  def test_vcards
    assert_equal patients(:joe), Vcards::Vcard.find_by_name('Patient').object
    
    patient = Patient.new
    patient.save
    vcard = Vcards::Vcard.new(:full_name => 'vcard patient')
    vcard.object = patient
    vcard.save
    assert_equal patient, Vcards::Vcard.find_by_name('vcard patient').object

    patient = Patient.new
    patient.save
    vcard = Vcards::Vcard.new(:full_name => 'patient vcards')
    vcard.save
    patient.vcards << vcard
    patient.save
    
    assert_equal patient, Vcards::Vcard.find_by_name('patient vcards').object
  end
end
