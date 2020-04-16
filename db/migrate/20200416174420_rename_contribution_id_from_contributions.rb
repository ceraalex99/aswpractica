class RenameContributionIdFromContributions < ActiveRecord::Migration[6.0]
  def change
    rename_column :contributions, :interaction_id, :contribution_id
  end
end
