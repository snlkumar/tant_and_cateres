class DashboardsController < ApplicationController
	# before_action :authenticate_admin!
	def index
		@accounts = Account.all
	end
 
    def demo
    	@accounts = Account.all
    	return render json: @accounts
    end

end