require File.dirname(__FILE__) + '/../test_helper'

include Vcards
class VcardTest < ActiveSupport::TestCase
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

  def test_active
    assert_equal Vcards::Vcard.active.count, Vcards::Vcard.count - 1
  end
end
