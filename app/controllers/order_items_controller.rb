class OrderItemsController < ApplicationController
	def create
		status = false
		order = Order.find params[:id]
		status = true if order.order_items.create(item_id: params[:item_id], quantity: params[:quantity])
		render json: {items: order.order_items.sort_by(&:created_at).map(&:make_response), status: status}
	end

	def mark_complete		
		order_item = OrderItem.find(params[:id])
		order_item.complete
		order_items=OrderItem.joins(:order).where("order_items.order_id=#{order_item.order_id}")
		render json: {items: order_items.sort_by(&:created_at).map(&:make_response), status: true}
	end

	def destroy
		order_item = OrderItem.find(params[:id])
		order_item.destroy
		order_items=OrderItem.joins(:order).where("order_items.order_id=#{order_item.order_id}")
		render json: {items: order_items.sort_by(&:created_at).map(&:make_response), status: true}
	end

end