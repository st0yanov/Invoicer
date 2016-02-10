class CreatePartnersTable < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :first_name, limit: 32
      t.string :last_name, limit: 32
      t.string :country, limit: 32
      t.string :city, limit: 32
      t.integer :postcode, null: true, default: nil
      t.string :address, limit: 64
      t.string :phone_number, limit: 16
      t.string :company_name, limit: 32, unique: true, null: true, default: nil
      t.integer :eik, null: true, default: nil, unique: true
      t.integer :vat_id, null: true, default: nil
    end
  end
end
