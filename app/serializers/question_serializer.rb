class QuestionSerializer < ActiveModel::Serializer
  attributes :user, :id, :title, :body, :created_at, :updated_at,
             :avatar_url, :created_at_to_human

  has_many :answers, :attachments

  def avatar_url
    object.user.authorizations.first.avatar_url if object.user.authorizations.present?
  end

  def created_at_to_human
    object.created_at.strftime('%B %d, %Y, %A')
  end
end
