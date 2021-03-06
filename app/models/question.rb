class Question < ActiveRecord::Base
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  validate :tags_inclusion, if: -> { Tag.count > 5 }
  validates :title, :body, :user, presence: true
  validates :title, length: { maximum: 255, minimum: 10 }, uniqueness: { message: 'Looks like this question has already been asked! Try to search for it', case_sensitive: false  }
  validates :body, length: { in: 10..1000 }

  before_validation :cut_spaces

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].blank? },
                                allow_destroy: true

  scope :created_today, -> { where('created_at > ?', Time.now.beginning_of_day) }

  default_scope { order 'created_at DESC' }

  def accepted_answer
    answers.find_by(accepted: true)
  end

  def tags_inclusion
    if tags.size == Tag.count
      errors.add(:tags, 'Omg! Can\'t beleive your answer responds to all tags at once! Some of them are redundant for sure :)')
    end
  end

  private

  def cut_spaces
    title.to_s.squish!
  end
end
