require File.dirname(__FILE__) + '/../test_helper'

class MailingTest < ActiveSupport::TestCase
  set_fixture_class :vcards => "Vcards::Vcard"

  fixtures :mailings, :doctors, :vcards
  
  def test_find
    assert_equal mailings(:unprinted).doctor, doctors(:doc_one)
    assert_equal mailings(:printed).doctor, doctors(:doc_one)
  end
end
