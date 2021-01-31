class RenameDescriptionColumnToCooks < ActiveRecord::Migration[5.2]
  def change
    rename_column :cooks, :description, :recipe
  end
end
