class Confirmer < ActionMailer::Base
  default from: "so@qna.com"

  def confirm_account(recepient, token)
    @account = recepient
    @token = token
    mail(to: recepient)
  end
end
