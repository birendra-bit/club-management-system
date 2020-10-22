class CreateRegisterations < ActiveRecord::Migration[6.0]
  def change
    create_table :registerations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
