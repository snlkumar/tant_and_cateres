class OrderItemsController < ApplicationController
	def create
		status = false
		order = Order.find params[:id]
		status = true if order.order_items.create(item_id: params[:item_id])
		render json: {items: order.order_items.map(&:make_response), status: status}
	end
end