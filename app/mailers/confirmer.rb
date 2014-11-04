class Confirmer < ActionMailer::Base
  default from: "so@example.com"

  def confirm_account(recepient, token)
    @account = recepient
    @token = token
    mail(to: recepient.email)
  end
end
