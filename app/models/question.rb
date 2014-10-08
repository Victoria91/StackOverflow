class Question < ActiveRecord::Base
	has_many :answers
	belongs_to :user
	has_many :attachments, as: :attachmentable

	validates :title, :body, presence: true
	validates :title, length: { maximum: 255 }

	accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].blank? },
                                allow_destroy: true


  def accepted_answer 
    self.answers.find_by(accepted: true)
  end

  def answer_to_reaccept(answer)
    answer.accepted?
  end

  def toggle_accepted(answer) 
    accepted_answer.update!(accepted: false) if accepted_answer and not answer_to_reaccept(answer)
		answer.toggle(:accepted).save!
	end

end
