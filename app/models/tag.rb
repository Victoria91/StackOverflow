class Tag < ActiveRecord::Base
  has_many :questions, through: :question_tags

  validates :name, presence: true
  validates :name, length: { maximum: 255 }

end
