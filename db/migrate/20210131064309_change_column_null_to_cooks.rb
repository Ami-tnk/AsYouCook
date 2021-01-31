class ChangeColumnNullToCooks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :cooks, :image_id, false
    change_column_null :cooks, :recipe, false
  end
end
