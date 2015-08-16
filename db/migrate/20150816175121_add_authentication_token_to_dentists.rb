class AddAuthenticationTokenToDentists < ActiveRecord::Migration
  def change
    add_column :dentists, :auth_token, :string, default: ''
    add_index :dentists, :auth_token, unique: true
  end
end
