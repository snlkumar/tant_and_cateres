class Order < ActiveRecord::Base
	has_many :order_items
	has_many :items, through: :order_items
	accepts_nested_attributes_for :order_items

	def complete
		order_items.where(status: 'Out').map(&:complete)
		update(status: 'In')
	end
end
