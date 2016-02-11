class CreateInvoicesTable < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.belongs_to :partner, index: true
      t.integer :type, limit: 1, default: 0
      t.string :number, limit: 32, null: false
      t.text :items, null: false
      t.decimal :total
      t.boolean :paid, default: false
      t.timestamps null: false
    end
  end
end
