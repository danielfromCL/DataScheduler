class CreateEventParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :event_participants do |t|
      t.string :user_id, null: false
      t.string :event_id, null: false
      t.string :status
      t.string :role

      t.timestamps
    end
  end
end
