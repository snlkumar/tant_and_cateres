class Item < ActiveRecord::Base
	validates :name, uniqueness: { case_sensitive: false }
	has_many :order_items
	has_many :orders, through: :order_items
	accepts_nested_attributes_for :order_items
	before_save :update_left, if: :quantity_changed?
	self.per_page = 10	
	class << self
		def search_by(q)
			where("name ilike ?", "%#{q}%")
		end
	end

	def view_format
		{name: "#{name} (#{left})", id: id}
	end

	def update_left
		self.left = self.quantity
	end
end
