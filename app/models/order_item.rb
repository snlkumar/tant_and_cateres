class OrderItem < ActiveRecord::Base
	belongs_to :order
	belongs_to :item

	def make_response
		resp = self.attributes
		resp['name'] = self.item.name
		resp
	end
end
