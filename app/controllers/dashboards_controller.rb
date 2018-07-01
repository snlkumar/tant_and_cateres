class DashboardsController < ApplicationController
	# before_action :authenticate_admin!
	def index
		@accounts = Account.all
	end
end