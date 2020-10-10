class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :is_admin, default: false
      t.string :email
      t.string :contact
      t.string :designation
      t.string :club
      t.string :address
      t.string :password_digest

      t.timestamps
    end
  end
end
