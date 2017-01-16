class OrdersController < ApplicationController
	before_action :authenticate_user!
	before_action :item, except: [:index, :create]
	def index
		@orders = Order.all
	end

	def new
		@order=Order.new
	end

	def edit
	end

	def create		
		order = Order.new params[:order].permit!
		valid = false
		valid = true if order.save
		message = valid ? "Updated successfuly." : order.errors.count
		render json: {id: order.id, valid: valid, message: message}
	end

	def update
		if @order.update_attributes(params[:order].permit!)
			flash[:notice] = "Updated successfuly."
			redirect_to orders_path
		else
			render 'edit'
		end
	end

	def destroy
		if @order.destroy
			flash[:notice] = "deleted successfuly"
		else
			flash[:notice] = "error"			
		end
			redirect_to orders_path
	end

	def items
		@items = @order.items
	end

	private
	def item
		@order ||= params[:id] ? Order.find(params[:id]) : Order.new 
	end

end

