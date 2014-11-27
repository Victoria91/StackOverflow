class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable

  accepts_nested_attributes_for :attachments

  validates :body, :question, presence: true

  after_create :send_email

  default_scope { order :created_at }

  def toggle_accepted
    @accepted_answer ||= question.accepted_answer
    @accepted_answer.update!(accepted: false) if @accepted_answer && !accepted
    toggle(:accepted).save!
  end

  private

  def send_email
    notify_subscribers(self)
  end

  def notify_subscribers(answer)
    AnswerNotifier.delay.author(self)
    answer.question.subscriptions.each do |subscription|
      AnswerNotifier.delay.subscribers(subscription.user, answer)
    end
  end
end
