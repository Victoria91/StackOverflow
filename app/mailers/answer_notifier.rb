class AnswerNotifier < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notifier.author.subject
  #
  def author(answer)
    mail to: answer.question.user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notifier.subscribers.subject
  #
  def subscribers
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
