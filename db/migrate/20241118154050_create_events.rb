class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.boolean :online, default: true
      t.string :city
      t.string :state
      t.string :country
      t.string :url
      t.datetime :from_date, null: false
      t.datetime :to_date, null: false

      t.timestamps
    end
  end
end
