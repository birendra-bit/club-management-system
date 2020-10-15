class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.datetime :event_time
      t.string :venu
      t.string :organizer
      t.integer :entry_fee
      t.integer :participants, array: true, default:[]

      t.timestamps
    end
  end
end
