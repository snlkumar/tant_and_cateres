class Order < ActiveRecord::Base
	has_many :invoices
	has_many :items, through: :invoices
	accepts_nested_attributes_for :invoices
end
