class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :body, :question_id
end
