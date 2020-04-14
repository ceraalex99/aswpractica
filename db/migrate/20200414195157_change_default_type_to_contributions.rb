class ChangeDefaultTypeToContributions < ActiveRecord::Migration[6.0]
  def change
    change_column_default :contributions, :type, nil
    add_column :contributions, :tipo, :string
  end
end
