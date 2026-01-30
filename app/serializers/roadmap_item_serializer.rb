class RoadmapItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :target_date, :priority, :created_at, :updated_at

  belongs_to :idea, serializer: IdeaSerializer, optional: true
end