require File.dirname(__FILE__) + '/../test_helper'

class DoctorTest < ActiveSupport::TestCase
  set_fixture_class :vcards => "Vcards::Vcard"
  fixtures :doctors, :vcards
  
  def test_vcards
    doc_one = doctors(:doc_one)
    
    assert_equal vcards(:doc_one_praxis), doc_one.praxis
    assert_equal vcards(:doc_one_private), doc_one.private

    assert_equal "Muster Peter", doc_one.name
    assert_equal "Praxis Dr. Tester & Co.", doctors(:doc_two).name
  end
end
