require File.dirname(__FILE__) + '/../test_helper'

class RecordTarmedTest < ActiveSupport::TestCase
  def test_defaults
    rec = RecordTarmed.new

    assert_equal 1, rec.quantity
    assert_equal Date.today, rec.date
  end
end
