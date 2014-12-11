class AnswerNotifier < ActionMailer::Base
  default from: "so@qna.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notifier.author.subject
  #
  def author(answer)
    @answer = answer
    mail(to: answer.question.user.email, subject: 'New answer on your question')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notifier.subscribers.subject
  #
  def subscribers(user, answer)
    @answer = answer
    mail(to: user.email, subject: 'New asnwer to a question you\'ve subscribed'
  end
end
