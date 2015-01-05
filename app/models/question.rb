class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  validates :title, :body, :user, presence: true
  validates :title, length: { maximum: 255 }

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].blank? },
                                allow_destroy: true

  scope :created_today, -> { where('created_at > ?', Time.now.beginning_of_day) }

  default_scope { order 'created_at DESC'}

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
