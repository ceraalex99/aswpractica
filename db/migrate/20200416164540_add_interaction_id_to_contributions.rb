class AddInteractionIdToContributions < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :interaction_id, :integer
  end
end
