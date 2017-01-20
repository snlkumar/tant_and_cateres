class OrderItemsController < ApplicationController
	# after_action :send_response, except: [:create]
	before_action :findobj, except: [:create]
	def create
		status = false
		order = Order.find params[:id]
		status = true if order.order_items.create(item_id: params[:item_id], quantity: params[:quantity])
		render json: {items: order.order_items.sort_by(&:created_at).map(&:make_response), status: status}
	end

	def mark_complete
		@oi.complete
		send_response
	end

	def destroy
		@oi.destroy
		send_response		
	end

	private
	def send_response
		order_items=OrderItem.joins(:order).where("order_items.order_id=#{@oi.order_id}")
		render json: {items: order_items.sort_by(&:created_at).map(&:make_response), status: true}
	end

	def findobj
		@oi = OrderItem.find params[:id]
	end

end