class Order < ActiveRecord::Base
	has_many :order_items
	has_many :items, through: :order_items
	accepts_nested_attributes_for :order_items
  class << self
		def search_by_name(params)
			where("name ILIKE ?", "%#{params[:q]}%")
		end

		def search_by_date(params)
			where(created_at: params[:from]..params[:to])
		end
	end

	def complete
		order_items.where(status: 'Out').map(&:complete)
		update(status: 'In')
	end
end
