class AddColumnTitle < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :title, :string
  end
end
