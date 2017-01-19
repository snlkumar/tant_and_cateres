class OrderItem < ActiveRecord::Base
	belongs_to :order
	belongs_to :item

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

end
