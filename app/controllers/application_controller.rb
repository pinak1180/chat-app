class ApplicationController < ActionController::Base
	before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :ensure_signup_complete
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :company_name) }
	  devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :company_name	) }
	end

  def ensure_signup_complete
    return if action_name == 'finish_signup'
    if current_user && (!current_user.company_name.present? || !current_user.email_verified?)
      redirect_to finish_signup_path(current_user)
    end
  end
end