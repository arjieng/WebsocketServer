class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ApplicationHelper
  protect_from_forgery with: :null_session
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }


  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActionController::ParameterMissing, with: :render_missing_parameters
  rescue_from ActiveModel::ForbiddenAttributesError, with: :render_forbidden_parameters
  rescue_from Exceptions::UnauthorizedException, with: :render_unauthorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  def render_unprocessable_entity_response(exception)
    render json: { error: exception.record.errors, status: 422 }, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message, status: 404 }, status: :not_found
  end

  def render_missing_parameters(exception)
    render json: { error: "#{exception.param} is missing.", status: 400 }, status: :bad_request
  end

  def render_forbidden_parameters(exception)
    render json: { error: exception.message, status: 400 }, status: :bad_request
  end

  def render_unauthorized(exception)
    logger.error "Exception: #{exception}"
    render json: { error: "You do not have sufficient permissions to perform this action.", status: 403 }, status: :forbidden
  end


  protected
    def configure_permitted_parameters
      # devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username])
      devise_parameter_sanitizer.permit(:sign_up, keys: [user: [:email, :username], user_admin: [:email, :username, group: [:group_name]]])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    end
end
