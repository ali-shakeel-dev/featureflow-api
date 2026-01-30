module Api
  module V1
    class RoadmapItemsController < ApplicationController
      def index
        roadmap_items = RoadmapItem.upcoming.by_priority(params[:priority]).page(params[:page]).per(20)
        render json: roadmap_items, each_serializer: RoadmapItemSerializer, status: :ok
      end

      def show
        roadmap_item = RoadmapItem.find(params[:id])
        render json: roadmap_item, serializer: RoadmapItemSerializer, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Roadmap item not found" }, status: :not_found
      end
    end
  end
end
