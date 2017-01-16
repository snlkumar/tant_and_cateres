class Item < ActiveRecord::Base
	has_many :order_items
	has_many :orders, through: :order_items
	accepts_nested_attributes_for :order_items

	# class << self
	# 	def search_by(q)
	# 		where("name ilike ?", "%#{q}%").map(&:view_format)
	# 	end
	# end

	# def view_format
	# 	{name: "#{name (left)}", id: id}
	# end
end
