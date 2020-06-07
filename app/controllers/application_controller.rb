class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :authenticate_user!, unless: :free_access?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def free_access?
    if params[:controller] == "items" && params[:action].in?(["index", "show"])
      return true
    elsif params[:controller] == "users" && params[:action].include?("new")
      return true
    elsif params[:controller].include?("api/categories") || params[:controller].include?("all_items")
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

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :email, :password, :first_name, :last_name, :first_kana, :last_kana, :birthday, :phone_number])
  end

end