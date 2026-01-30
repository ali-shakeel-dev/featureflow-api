class IdeaSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :category, :votes_count, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
  has_many :comments, serializer: CommentSerializer
end