class Mail < ActionMailer::Base

  def message_to_zytolabor(sent_at = Time.now)
    @subject    = 'Mail#message_to_zytolabor'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end
end
