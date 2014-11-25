class DailyMailer < ActionMailer::Base
  default from: "from@example.com"

  def digest(user)
    mail to: user.email
  end
end
