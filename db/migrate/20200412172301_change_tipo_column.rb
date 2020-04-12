class ChangeTipoColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :contributions, :tipo, :type
  end
end
