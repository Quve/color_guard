class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper ColorGuard::Helper
  helper_method :current_user

  def index
  end

  private

  def current_user
    params[:user_id].to_i
  end

end
