require File.dirname(__FILE__) + '/../test_helper'

class MailTest < ActionMailer::TestCase
  set_fixture_class :vcards => "Vcards::Vcard"

  tests Mail
  def test_message_to_zytolabor
    @expected.subject = 'Mail#message_to_zytolabor'
    @expected.body    = read_fixture('message_to_zytolabor')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Mail.create_message_to_zytolabor(@expected.date).encoded
  end

end
