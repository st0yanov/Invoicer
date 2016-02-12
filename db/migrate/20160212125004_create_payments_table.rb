class CreatePaymentsTable < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :invoice, index: true
      t.string :gateway, null: false
      t.date :date, null: false
      t.string :transaction, null: false
      t.decimal :value, null: false
    end
  end
end
