class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from StandardError, with: :internal_error

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def current_user
    @current_user ||= User.find_by(id: user_id_from_token)
  end

  def user_id_from_token
    # If using devise-token-auth or JWT
    # Extract from Authorization header
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def parameter_missing(error)
    render json: { error: error.message }, status: :bad_request
  end

  def internal_error(error)
    Rails.logger.error(error)
    render json: { error: "Internal Server Error" }, status: :internal_server_error
  end
end