class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, uniqueness: { scope: :question, message: 'Thank you, but this answer has already been given :)',
                                 case_sensitive: false }
  validates :question, presence: true
  validates :body, presence: { message: 'Please type an answer' }

  before_validation :cut_spaces

  accepts_nested_attributes_for :attachments

  after_create :send_email

  default_scope { order :created_at }

  def toggle_accepted
    @accepted_answer ||= question.accepted_answer
    @accepted_answer.update!(accepted: false) if @accepted_answer && !accepted
    toggle(:accepted).save!
  end

  private

  def send_email
    notify_subscribers
  end

  def notify_subscribers
    AnswerNotifier.author(self).deliver if question.notifications
    question.subscriptions.each do |subscription|
      AnswerNotifier.subscribers(subscription.user, self).deliver
    end
  end

  def cut_spaces
    body.to_s.squish!
  end
end
