class DeleteEmailFromUser < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :email, :google_id
  end
end
