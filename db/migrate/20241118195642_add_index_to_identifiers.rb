class AddIndexToIdentifiers < ActiveRecord::Migration[7.0]
  def change
    add_index :companies, :identifier, unique: true
    add_index :users, :identifier, unique: true
  end
end
