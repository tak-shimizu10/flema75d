class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :authenticate_user!, unless: :free_access?

  private

  def free_access?
    if params[:controller] == "items" && params[:action].in?(["index", "show", "edit"])
      return true
    elsif params[:controller].include?("api/selects") || params[:controller].include?("categories")
      return true
    else
      return false
    end
  end

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials[:basic_auth][:user] &&
      password == Rails.application.credentials[:basic_auth][:pass]
    end
  end
end
