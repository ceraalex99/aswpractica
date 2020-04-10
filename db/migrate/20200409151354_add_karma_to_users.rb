class AddKarmaToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :karma, :integer, default: 0
    change_column_default :contributions, :user_id, nil
  end
end
