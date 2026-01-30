module Api
  module V1
    class IdeasController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show, :trending, :recent]
      before_action :set_idea, only: [:show, :update, :destroy, :vote, :unvote]
      before_action :authorize_user!, only: [:update, :destroy]

      def index
        ideas = Idea.all
        ideas = ideas.by_status(params[:status]) if params[:status].present?
        ideas = ideas.by_category(params[:category]) if params[:category].present?
        ideas = ideas.page(params[:page]).per(20)
        render json: ideas, each_serializer: IdeaSerializer, status: :ok
      end

      def show
        render json: @idea, serializer: IdeaDetailSerializer, status: :ok
      end

      def create
        idea = current_user.ideas.build(idea_params)
        if idea.save
          render json: idea, serializer: IdeaDetailSerializer, status: :created
        else
          render json: { errors: idea.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @idea.update(idea_params)
          render json: @idea, serializer: IdeaDetailSerializer, status: :ok
        else
          render json: { errors: @idea.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @idea.destroy
        head :no_content
      end

      def trending
        ideas = Idea.trending.page(params[:page]).per(20)
        render json: ideas, each_serializer: IdeaSerializer, status: :ok
      end

      def recent
        ideas = Idea.recent.page(params[:page]).per(20)
        render json: ideas, each_serializer: IdeaSerializer, status: :ok
      end

      def vote
        vote = current_user.votes.build(idea: @idea)
        if vote.save
          render json: @idea, serializer: IdeaDetailSerializer, status: :created
        else
          render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def unvote
        vote = Vote.find_by(user: current_user, idea: @idea)
        if vote&.destroy
          render json: @idea, serializer: IdeaDetailSerializer, status: :ok
        else
          render json: { error: "Vote not found" }, status: :not_found
        end
      end

      private

      def set_idea
        @idea = Idea.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Idea not found" }, status: :not_found
      end

      def authorize_user!
        render json: { error: "Unauthorized" }, status: :forbidden unless @idea.user == current_user || current_user.admin?
      end

      def idea_params
        params.require(:idea).permit(:title, :description, :category)
      end
    end
  end
end
