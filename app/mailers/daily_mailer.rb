class DailyMailer < ActionMailer::Base
  default from: "so@qna.com"

  def digest(user)
    mail to: user.email
  end
end
