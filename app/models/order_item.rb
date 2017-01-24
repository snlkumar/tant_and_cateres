class OrderItem < ActiveRecord::Base
	belongs_to :order
	belongs_to :item
	validate :record, on: :create
	after_create :update_item
	after_update :reset_left, if: :status_changed?
	after_destroy :reset_left, if: Proc.new {|p| p.status=='Out'}

	def make_response		
		resp = self.attributes
		resp['name'] = self.item.name
		resp['daily_charge'] = self.item.charge
		resp['days'] = calculate_days
		resp
	end

	def complete
		days = calculate_days == 0 ? 1 : calculate_days
		self.update(status: 'In', charge: (days*self.item.charge.to_i)*quantity )
	end
	
	def calculate_days
		if self.status == 'Out'
		  return (Date.today - created_at.to_date).to_i
		else
			return (updated_at.to_date - created_at.to_date).to_i
		end
	end

	def update_item
		left = item.left - quantity
		Item.update(self.item.id, left: left )
	end

	def reset_left
		Item.update(item_id, left: item.left+quantity )
		amount = order.amount ? order.amount.to_i+charge.to_i : charge.to_i
		Order.update(order_id, amount: amount )
	end
	
	def record		
		if self.order.status == 'In'
			self.errors[:base] << "This order is not active"
		elsif self.item.left < self.quantity
			self.errors[:base] << "Invalid quantity"
		end
	end

end
