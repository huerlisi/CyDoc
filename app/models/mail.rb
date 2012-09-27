class Mail < ActionMailer::Base

  def message_to_zytolabor
    @subject    = 'Mail#message_to_zytolabor'
    @body       = {}
    @recipients = ''
    @from       = ''
    @headers    = {}
  end
end
