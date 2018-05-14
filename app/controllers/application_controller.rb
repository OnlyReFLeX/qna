class ApplicationController < ActionController::Base
  before_action :gon_user
  before_action :ensure_signup_complete

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def ensure_signup_complete
    if current_user&.temp_email?
      return if %w[confirmations sessions].include?(controller_name)
      redirect_to add_email_user_path(current_user)
    end
  end

  def gon_user
    gon.user_id = current_user.id if user_signed_in?
    gon.is_user_signed_in = user_signed_in?
  end
end
