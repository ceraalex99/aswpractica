class AddTitleToContribution < ActiveRecord::Migration[6.0]
  def change
    change_column :contributions, :points, :integer, default: 0
    change_column :contributions, :user_id, :integer, default: 1
    change_column :contributions, :tipo, :string, default: "url"
    add_column :contributions, :url, :string
    add_column :contributions, :title, :string
  end
end
