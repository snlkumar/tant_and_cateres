class HomeController < ApplicationController
	layout 'home'
	def index
		if current_user
		  redirect_to '/items'
		elsif request.subdomain.blank?
			redirect_to '/admins/sign_in'
		else
		  redirect_to '/users/sign_in'
		end
	end
end