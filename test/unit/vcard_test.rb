# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'

include Vcards
class VcardTest < ActiveSupport::TestCase
  def test_new
    empty_new = Vcards::Vcard.new
    assert_kind_of(Vcards::Vcard, empty_new)
    
    empty_new.full_name = 'Empty Name'
    empty_new.save
    assert_equal empty_new, Vcards::Vcard.find_by_full_name('Empty Name')

    vcard_new = Vcards::Vcard.new(:full_name => 'Vcard Name', :nickname => 'Nick', :active => true)
    vcard_new.save
    assert_kind_of(Vcards::Vcard, vcard_new)
    
    address_new = Vcards::Vcard.new(:full_name => 'Address Name', :street_address => 'Strasse 1')
    address_new.save
    address_new.reload
    assert_kind_of(Vcards::Vcard, address_new)
    assert_equal 'Strasse 1', address_new.street_address
    
    address_new.postal_code = "3333"
    address_new.save
    address_new.reload
    assert_equal 'Strasse 1', address_new.street_address
    assert_equal '3333', address_new.postal_code
  end

  def test_find
    assert_equal Vcards::Vcard.find_by_full_name('Full Name'), vcards(:full_name)
    assert_equal Vcards::Vcard.find_by_full_name('full name'), vcards(:full_name)

    assert_equal Vcards::Vcard.find_by_given_name('John'), vcards(:simple_person)
    assert_equal Vcards::Vcard.find_all_by_family_name('Doe'), vcards(:us_person, :simple_person)
  end

  def test_find_by_name
    assert_equal Vcards::Vcard.find_by_name('John W.'), vcards(:us_person)
    assert_equal Vcards::Vcard.find_by_name('joe'), vcards(:us_person)
    assert_equal Vcards::Vcard.find_all_by_name('Doe'), vcards(:us_person, :simple_person)
  end

  def test_find_collate
    assert_equal Vcards::Vcard.find_by_name('celine'), vcards(:de_person)
    assert_equal Vcards::Vcard.find_by_name('Müller'), vcards(:de_person)
    assert_equal Vcards::Vcard.find_by_name('ändi'), vcards(:de_person)
  end

  def test_object
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

  def test_active
    assert_equal Vcards::Vcard.active.count, Vcards::Vcard.count - 1
  end

  def test_scope_by_name
    assert_equal [vcards(:patient)], Vcards::Vcard.by_name('Patient')
    assert_equal 1, Vcards::Vcard.by_name('Patient').count
    
    assert_equal 2, Vcards::Vcard.by_name('Doe').count
  end
end
