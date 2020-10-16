class AddPasswordResetColumnsToUser < ActiveRecord::Migration[6.0]

  add_column :users, :reset_password_token, :string
  add_column :users, :reset_password_sent_at, :datetime
  def change
  end
end
