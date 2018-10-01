class OrderItemsController < ApplicationController
	# after_action :send_response, except: [:create]
	before_action :findobj, except: [:create]
	def create		
		order = Order.find params[:id]
		orderitem = order.order_items.new(item_id: params[:item_id], quantity: params[:quantity], status: params[:status])
		if orderitem.valid?
		  orderitem.save
		  return render json: {items: order.order_items.sort_by(&:created_at).map(&:make_response), status: true}
		else
		  return render json: {status: false, errors: orderitem.errors.full_messages}
		end		
	end

	def mark_complete
		params[:status]=='O' ? @oi.out : @oi.complete		
		send_response
	end

	def change_quantity
		if @oi.update_attributes(quantity: params[:quantity])
			return render json: {status: true, message: 'Item updated successfully.', quantity: params[:quantity]}
		else
		  return render json: {status: false, errors: @oi.errors.full_messages}
		end
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