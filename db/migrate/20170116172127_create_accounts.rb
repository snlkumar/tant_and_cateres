class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
    	t.string :email
    	t.string :domain
      t.timestamps null: false
    end
  end
end
