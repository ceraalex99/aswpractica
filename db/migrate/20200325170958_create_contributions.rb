class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.string :tipo, default: "url"
      t.string :text
      t.integer :user_id , default: 1
      t.integer :points, default: 0

      t.timestamps
    end
  end
end
