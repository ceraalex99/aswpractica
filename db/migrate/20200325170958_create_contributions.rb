class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.string :tipo
      t.string :text
      t.integer :user_id
      t.integer :points

      t.timestamps
    end
  end
end
