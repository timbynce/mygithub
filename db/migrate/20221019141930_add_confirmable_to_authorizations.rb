class AddConfirmableToAuthorizations < ActiveRecord::Migration[6.1]
  def change
    add_column :authorizations, :confirmed, :boolean, default: false
    add_column :authorizations, :confirmation_token, :string
    add_column :authorizations, :temporary_email, :string

    add_index :authorizations, :confirmed
    add_index :authorizations, :confirmation_token
  end
end
