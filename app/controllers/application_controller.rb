class ApplicationController < ActionController::Base
  before_action :gon_user
  before_action :ensure_signup_complete

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_path, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def ensure_signup_complete
    if current_user&.temp_email?
      return if %w[confirmations sessions].include?(controller_name)
      redirect_to add_email_users_path
    end
  end

  def gon_user
    gon.user_id = current_user.id if user_signed_in?
    gon.is_user_signed_in = user_signed_in?
  end
end
