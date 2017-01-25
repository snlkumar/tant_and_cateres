class RegistrationsController < Devise::RegistrationsController


  #Overriding Devise's registration controller to check for subdomain 
  #Only allow registration if subdomain is absent or is www
  def new 
    if (request.subdomain.blank? || request.subdomain == "www") && admin_signed_in?
        super
    else
        flash[:notice] = "Access Restricted"
        redirect_to admin_session_path
    end

  end  

  protected

  def after_sign_up_path_for(resource)    
    new_user_session_url(subdomain: resource.subdomain)
  end

    def after_inactive_sign_up_path_for(resource)
        new_user_session_url(subdomain: resource.subdomain)
   end

end