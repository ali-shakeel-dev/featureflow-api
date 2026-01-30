module Api
  module V1
    module Admin
      class RoadmapItemsController < ApplicationController
        before_action :authenticate_user!
        before_action :authorize_admin!
        before_action :set_roadmap_item, only: [:show, :update, :destroy]

        def index
          roadmap_items = RoadmapItem.all.page(params[:page]).per(20)
          render json: roadmap_items, each_serializer: RoadmapItemSerializer, status: :ok
        end

        def create
          roadmap_item = RoadmapItem.new(roadmap_item_params)
          if roadmap_item.save
            render json: roadmap_item, serializer: RoadmapItemSerializer, status: :created
          else
            render json: { errors: roadmap_item.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @roadmap_item.update(roadmap_item_params)
            render json: @roadmap_item, serializer: RoadmapItemSerializer, status: :ok
          else
            render json: { errors: @roadmap_item.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @roadmap_item.destroy
          head :no_content
        end

        private

        def set_roadmap_item
          @roadmap_item = RoadmapItem.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Roadmap item not found" }, status: :not_found
        end

        def authorize_admin!
          render json: { error: "Unauthorized" }, status: :forbidden unless current_user.admin?
        end

        def roadmap_item_params
          params.require(:roadmap_item).permit(:title, :description, :status, :target_date, :idea_id, :priority)
        end
      end
    end
  end
end
