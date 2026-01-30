module Api
  module V1
    module Admin
      class IdeasController < ApplicationController
        before_action :authenticate_user!
        before_action :authorize_admin!
        before_action :set_idea, only: [:show, :update, :destroy, :change_status]

        def index
          ideas = Idea.all.page(params[:page]).per(20)
          render json: ideas, each_serializer: IdeaSerializer, status: :ok
        end

        def update
          if @idea.update(admin_idea_params)
            render json: @idea, serializer: IdeaDetailSerializer, status: :ok
          else
            render json: { errors: @idea.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @idea.destroy
          head :no_content
        end

        def change_status
          if @idea.update(status: params[:status])
            render json: @idea, serializer: IdeaDetailSerializer, status: :ok
          else
            render json: { errors: @idea.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def set_idea
          @idea = Idea.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Idea not found" }, status: :not_found
        end

        def authorize_admin!
          render json: { error: "Unauthorized" }, status: :forbidden unless current_user.admin?
        end

        def admin_idea_params
          params.require(:idea).permit(:title, :description, :category, :status)
        end
      end
    end
  end
end
