class Order < ActiveRecord::Base
	has_many :order_items
	has_many :items, through: :order_items
	validates_presence_of :name, :address, :phone, :outdate
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
		update(status: 'Completed')
	end

	def dispatched
		order_items.where(status: 'Initial').map(&:out)
		update(status: 'Dispatched')
	end

	def check_status
		current = self.order_items.map(&:status).uniq
		if current.length > 1
			if current.include?('Initial')
			  self.status = 'Partialy Dispatched'
			elsif current.include?('In')
				self.status = 'Partialy Completed'
			end
		elsif current[0] == 'In'
			self.status = 'Completed'
		elsif current[0] == 'Out'
			self.status = 'Dispatched'
		end
		return self
	end
end
