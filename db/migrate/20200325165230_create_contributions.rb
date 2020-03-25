class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.string :type
      t.string :text
      t.integer :points
      t.integer :user_id

      t.timestamps
    end
  end
end
