class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order
			t.references :item
			t.integer :quantity
			t.integer :day
			t.string :charge
			t.string :status, default: 'Out'
      t.timestamps null: false
    end
  end
end
