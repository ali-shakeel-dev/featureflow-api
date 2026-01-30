class IdeaDetailSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :category, :votes_count, :created_at, :updated_at, :user_has_voted

  belongs_to :user, serializer: UserSerializer
  has_many :comments, serializer: CommentSerializer
  has_many :voters, serializer: UserSerializer

  def user_has_voted
    current_user && object.voters.include?(current_user)
  end
end