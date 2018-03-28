class CreateUsersTable < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.column :email,     :string
      t.column :auth_data, :string
    end
  end
end
