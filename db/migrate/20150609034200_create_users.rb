class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_id, null: false
      t.string :password, null: false
      t.string :current_token, null: false, default: ""
      t.string :last_token, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at

      t.timestamps
    end
  end
end
