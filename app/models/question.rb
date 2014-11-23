class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :user
  has_many :attachments, as: :attachmentable
  has_many :votes
  has_many :subscriptions

  validates :title, :body, :user, presence: true
  validates :title, length: { maximum: 255 }

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].blank? },
                                allow_destroy: true

  def accepted_answer
    answers.find_by(accepted: true)
  end

  def vote_up
    update(rating: rating + 1)
  end

  def vote_down
    update(rating: rating - 1)
  end
end