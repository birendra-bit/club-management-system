class CreateNewsfeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :newsfeeds do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :content
      t.string :image_url

      t.timestamps
    end
  end
end
