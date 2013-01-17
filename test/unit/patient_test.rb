# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'

class PatientTest < ActiveSupport::TestCase
  def test_vcards
    # Find nobody; return nil
    assert_nil Vcards::Vcard.find_by_name('XXXX')

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
    patient.vcard = vcard
    patient.save
    assert_equal patient, Vcards::Vcard.find_by_name('patient vcards').object
  end

  def test_new_with_vcard_attributes
#    patient = Patient.new(:full_name => 'address patient')
#    patient.save
    
#    found_patient = Patient.by_name('address patient')
#    assert_equal patient, found_patient
#    assert_equal 'address patient', patient.name
  end

  def test_vcard_delegation
#    patient = Patient.new(:full_name => 'address patient')
#    assert_equal 'address patient', patient.vcard.full_name
#    assert_equal 'address patient', patient.full_name
  end

  def test_vcard_address
#    patient = Patient.new(:full_name => 'address patient', :street_address => 'Street 1')
#    assert_equal 'Street 1', patient.vcard.street_address
#    patient.save
    
#    found_patient = Patient.by_name('address patient')
#    assert_equal patient, found_patient
#    assert_equal 'address patient', patient.name
#    assert_equal 'Street 1', patient.vcard.street_address
  end

  def test_by_name
    assert_equal [patients(:joe)], Patient.by_name('Patient')
    assert_equal 1, Patient.by_name('Patient').count

    assert_equal [patients(:us_patient), patients(:simple_patient)], Patient.by_name('Doe')
    assert_equal 2, Patient.by_name('Doe').count
  end

  def test_by_date
    assert_equal [], Patient.by_date('1.1.2000')
    assert_equal 0, Patient.by_date('1.1.200').count

    assert_equal [patients(:joe)], Patient.by_date('3.2.1990')
    assert_equal 1, Patient.by_date('3.2.1990').count

    assert_equal [patients(:joe)], Patient.by_date('3.2.90')
    assert_equal 1, Patient.by_date('3.2.90').count

    assert_equal [patients(:young_one), patients(:old_two)], Patient.by_date('4.2.01')
    assert_equal 2, Patient.by_date('4.2.01').count
  end
end
