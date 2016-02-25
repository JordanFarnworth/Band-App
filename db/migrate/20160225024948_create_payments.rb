class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :entity, index: true, foreign_key: true
      t.string :uuid
      t.string :gateway
      t.decimal :amount, precision: 6, scale: 2
      t.string :state
      t.string :braintree_transaction_id
      t.text :parameters

      t.timestamps null: false
    end

    add_column :entities, :braintree_customer_id, :string
    add_column :entities, :subscription_expires_at, :datetime
  end
end
