class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :phone, null: false
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
  end
end
