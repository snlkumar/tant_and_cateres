class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :status, default: 'Out'
      t.string :amount
      t.datetime :indate
      t.timestamps null: false
    end
  end
end
