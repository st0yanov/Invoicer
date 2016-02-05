class CreatePartnersTable < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :first_name, limit: 32
      t.string :last_name, limit: 32
      t.string :country, limit: 32
      t.string :city, limit: 32
      t.integer :postcode
      t.string :address, limit: 64
      t.string :phone_number, limit: 16
      t.string :company_name, limit: 32, null: true, default: nil
      t.integer :eik
      t.integer :vat_id
    end
  end
end
