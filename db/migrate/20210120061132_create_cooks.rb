class CreateCooks < ActiveRecord::Migration[5.2]
  def change
    create_table :cooks do |t|
      t.integer :user_id, null: false
      t.string :cooking_name, null: false
      t.string :image_id
      t.text :description
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
