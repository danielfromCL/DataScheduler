class AddRelationsToModels < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_participants, :user, null: false, foreign_key: true
    add_reference :event_participants, :event, null: false, foreign_key: true
    add_reference :users, :company, foreign_key: true
    add_index :event_participants, %i[user_id event_id], unique: true
  end
end
