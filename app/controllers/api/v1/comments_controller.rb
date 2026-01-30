module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate_user!, except: [:index]
      before_action :set_idea
      before_action :set_comment, only: [:destroy]

      def index
        comments = @idea.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
        render json: comments, each_serializer: CommentSerializer, status: :ok
      end

      def create
        comment = @idea.comments.build(comment_params)
        comment.user = current_user
        if comment.save
          render json: comment, serializer: CommentSerializer, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        render json: { error: "Unauthorized" }, status: :forbidden unless @comment.user == current_user || current_user.admin?
        @comment.destroy
        head :no_content
      end

      private

      def set_idea
        @idea = Idea.find(params[:idea_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Idea not found" }, status: :not_found
      end

      def set_comment
        @comment = Comment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Comment not found" }, status: :not_found
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
