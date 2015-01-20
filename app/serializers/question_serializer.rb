class QuestionSerializer < ActiveModel::Serializer
  attributes :user, :id, :title, :body, :created_at, :updated_at,
             :avatar_url, :created_at_to_human

  has_many :answers, :attachments

  def avatar_url
    if object.user.try(:authorizations).present?
      object.user.authorizations.first.avatar_url
    else
      ActionController::Base.helpers.asset_path('user.png')
    end
  end

  def created_at_to_human
    object.created_at.strftime('%B %d, %Y, %A')
  end
end
