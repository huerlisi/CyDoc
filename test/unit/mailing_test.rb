require File.dirname(__FILE__) + '/../test_helper'

class MailingTest < ActiveSupport::TestCase
  fixtures :mailings
  
  def test_find
    assert_equal mailings(:unprinted)["doctor_id"], 1
    assert_equal mailings(:printed)["doctor_id"], 1
  end
end
