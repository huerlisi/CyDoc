require File.dirname(__FILE__) + '/../test_helper'

class PatientTest < ActiveSupport::TestCase
  def test_vcard
    assert_equal [vcards(:simple_person)], patients(:joe).vcards
  end
end
