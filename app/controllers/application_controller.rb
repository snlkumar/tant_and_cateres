class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery 
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_mailer_host
  
	protected

	def set_mailer_host
		debugger
	    ActionMailer::Base.default_url_options[:host] = request.host_with_port
	    Time.zone="New Delhi"
	end

	def after_sign_in_path_for(resource)
	  if user_signed_in?
	    calanders_path	
	    # items_path
	  elsif admin_signed_in?
	  	dashboards_path
	  end
	end

	def configure_permitted_parameters
	  devise_parameter_sanitizer.permit(:sign_up, keys: [:subdomain, :mobile, :address])
	  
	end
end
