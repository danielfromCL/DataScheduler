class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :identifier, null: false
      t.string :company_id
      t.string :email

      t.timestamps
    end
  end
end
