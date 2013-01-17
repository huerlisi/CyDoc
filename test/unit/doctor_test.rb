# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'

class DoctorTest < ActiveSupport::TestCase
  def test_offices
    doctor = doctors(:single)
    assert_kind_of(Doctor, doctor)
    
    assert_equal [], doctor.offices

    office = Office.new
    office.save
    
    doctor.offices << office
    assert_equal [office], doctor.offices

    # Test office two from fixture
    assert_equal [offices(:praxis_two)], doctors(:colleague_one).offices
    assert_equal offices(:praxis_two), doctors(:colleague_one).office
  end

  def test_colleagues
    # :test is not part of any office
    assert_equal [doctors(:test)], doctors(:test).colleagues
    
    # :colleague_one's only colleague of himself
    assert_equal [doctors(:colleague_one)], doctors(:colleague_one).colleagues
    
    assert_equal 1, offices(:praxis_two).doctors.count

    # add :test to :praxis_two...
    doc1 = doctors(:test)
    off2 = offices(:praxis_two)
    off2.doctors << doc1
    # ...now there's an office of two
    assert_equal 2, off2.doctors.count

    doc1.reload
    assert_equal [doctors(:colleague_one), doc1].sort{|x, y| y.id <=> x.id}, doc1.colleagues.sort{|x, y| y.id <=> x.id}
    assert_equal [doctors(:colleague_one), doctors(:test)].sort{|x, y| y.id <=> x.id}, doctors(:test).colleagues.sort{|x, y| y.id <=> x.id}
  end

  def test_account
    assert_kind_of(Accounting::Account, doctors(:test).account)
  end
end
