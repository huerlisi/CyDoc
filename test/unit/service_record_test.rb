# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'

class ServiceRecordTest < ActiveSupport::TestCase
  def test_defaults
    rec = ServiceRecord.new

    assert_equal 1, rec.quantity
    assert_equal Date.today, rec.date

    # Override defaults
    rec.quantity = 2
    rec.date = '2000-01-02'
    
    # Before save
    assert_equal 2, rec.quantity
    assert_equal DateTime.parse('2000-01-02').strftime('%Y-%m-%d'), rec.date.strftime('%Y-%m-%d')
  end

  def test_create
    rec = ServiceRecord.new(:code => '01.0010')

    # Override defaults
    rec.quantity = 2
    rec.date = '2000-01-02'

    # Not NULL fields
    rec.provider = doctors(:test)
    rec.biller = doctors(:test)
    rec.responsible = doctors(:test)

    # After save
    rec.save
    assert_equal 2, rec.quantity
    assert_equal DateTime.parse('2000-01-02').strftime('%Y-%m-%d'), rec.date.strftime('%Y-%m-%d')
    assert_equal '01.0010', rec.code
  end
  
  def test_patient_assignment
    rec = ServiceRecord.new(:code => '01.0010')
    patients(:joe).service_records << rec
    
    # Now there's a record
    assert_equal 1, patients(:joe).service_records.size

    # Take provider, biller, responsible from patient
    assert_equal patients(:joe).doctor, rec.provider
    assert_equal patients(:joe).doctor, rec.biller
    assert_equal patients(:joe).doctor, rec.responsible
  end

  def test_duplicate_record
    # old_one has a fixtured tarmed record
    assert_equal 1, patients(:old_one).service_records.size

    rec = ServiceRecord.new(:code => '01.0010')
    patients(:old_one).service_records << rec
    
    # Now there's a second record
    assert_equal 2, patients(:old_one).service_records.size
  end
end
