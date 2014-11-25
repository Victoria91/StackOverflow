class AnswerNotifier < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notifier.author.subject
  #
  def author(answer)
    @answer = answer
    mail to: answer.question.user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notifier.subscribers.subject
  #
  def subscribers(user, answer)
    @answer = answer
    mail to: user.email
  end
end
