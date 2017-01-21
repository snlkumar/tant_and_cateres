class HomeController < ApplicationController
	layout 'home'
	def index
		# debugger
		if current_user
		  redirect_to '/items'
		# elsif request.subdomain
		#   redirect_to '/users/sign_in'
		end
	end
end