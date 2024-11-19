class AddColumnLoginTokenUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :login_token, :string
    add_column :users, :login_token_generated_at, :datetime

    add_index :users, :login_token, unique: true
  end
end
