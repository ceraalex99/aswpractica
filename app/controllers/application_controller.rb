class ApplicationController < ActionController::Base
  def current_user
    return unless cookies.signed[:user_id]
    @current_user ||= User.find(cookies.signed[:user_id])
  end

  def current_api_user
    return unless request.headers['Authorization']
    @current_api_user ||= User.find_by_google_id(request.headers['Authorization'])
  end

  def api_auth
    unless current_api_user
      head :unauthorized
    end
  end

end
