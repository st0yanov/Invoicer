class CreateSettingsTable < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :setting
      t.string :value
    end
  end
end
