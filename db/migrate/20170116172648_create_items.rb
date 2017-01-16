class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :quantity
      t.integer :left
      t.integer :charge
      t.boolean :status, default: true
      t.timestamps null: false
    end
  end
end
