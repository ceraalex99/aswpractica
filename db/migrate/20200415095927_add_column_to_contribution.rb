class AddColumnToContribution < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :post_id, :integer
  end
end
