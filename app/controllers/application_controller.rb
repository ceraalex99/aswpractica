class ApplicationController < ActionController::Base
  def current_user
    return unless cookies.signed[:user_id]
    @current_user ||= User.find(cookies.signed[:user_id])
  end
end
