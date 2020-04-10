class ChangePointsDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :contributions, :points, 1
  end
end
