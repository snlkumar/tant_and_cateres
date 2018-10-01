class OrderItem < ActiveRecord::Base
	belongs_to :order
	belongs_to :item
	validate :record
	# after_create :update_item
	after_update :reset_left, if: :status_changed?
	# after_destroy :reset_left #, if: Proc.new {|p| p.status=='Out'}

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

	def out
		self.update(status: 'Out')
	end
	
	def calculate_days
		if self.status == 'Out'
			# date = created_at.to_date == order.outdate.to_date ? order.outdate.to_date : created_at.to_date
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
		if status =='In'
			amount = order.amount ? order.amount.to_i+charge.to_i : charge.to_i
			Order.update(order_id, amount: amount, status: 'In' )
			Item.update(item_id, left: item.left + quantity )
		elsif status == 'Out'
			Item.update(item_id, left: item.left - quantity )
		end
				
		# if self.status == 'In' || (!OrderItem.exists?(self) && self.status=="Out")
		# 	Item.update(item_id, left: item.left+quantity )
		# 	amount = order.amount ? order.amount.to_i+charge.to_i : charge.to_i
		# 	Order.update(order_id, amount: amount )
		# end
	end
	
	def record
		if self.order.status == 'In'
			self.errors[:base] << "This order is not active"
		elsif self.item.left < self.quantity
			self.errors[:base] << "Invalid quantity"
	    elsif self.new_record?
	    	does_already_exist
		end
	end

	private
	def does_already_exist
		item_exist = OrderItem.where(order_id: self.order_id, item_id: self.item_id)[0]
		if item_exist
			self.errors[:base] << item_exist.item.name + " already added you can update if you want"
		end
	end

end
