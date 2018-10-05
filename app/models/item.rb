class Item < ActiveRecord::Base
	validates :name, uniqueness: { case_sensitive: false }
	has_many :order_items
	has_many :orders, through: :order_items
	accepts_nested_attributes_for :order_items
	before_save :update_left, if: :quantity_changed?
	before_destroy :check_dependency
	self.per_page = 10	
	class << self
		def search_by(q)
			filter_items(q).map(&:view_format)
		end

		def filter_items(input)
			where("name ilike ?", "%#{input}%")
		end	
	end    

	def view_format
		{name: "#{name} (#{left})", id: id}
	end

	def update_left
		self.left = self.quantity
	end

	private
	def check_dependency
		orders = Order.where.not(status: ['Completed', 'In']).includes(:order_items).where("order_items.item_id" => 2)
		orders.any? ? self.errors[:base] << "Has dependency" : ''
	end
end
