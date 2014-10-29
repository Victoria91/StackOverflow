class Confirmer < ActionMailer::Base
  default from: "from@example.com"

  def confirm_account(recepient, token)
    @account = recepient
    @token = token
    mail(to: recepient.email)
  end
end
