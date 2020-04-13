class AddAboutColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :about, :string, default: ""
  end
end
